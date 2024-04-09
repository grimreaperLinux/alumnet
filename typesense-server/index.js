import { getFirestore, collection, onSnapshot, collectionGroup  } from 'firebase/firestore';
import app from './firebase-config.js'
import Typesense from 'typesense';

const db = getFirestore(app);
const typesense = new Typesense.Client({
    nodes: [{ host: 'localhost', port: 8108, protocol: 'http' }],
    apiKey: 'xyz',
});

async function indexDocumentInTypesense(collectionName, docId, data) {
  return typesense.collections(collectionName).documents().upsert({
    id: docId,
    ...data,
  });
}

function deleteDocumentFromTypesense(collectionName, docId) {
  return typesense.collections(collectionName).documents(docId).delete();
}

async function ensureTypesenseCollectionExists(collectionName, fields) {
  try {
    await typesense.collections(collectionName).retrieve();
    console.log(`Typesense collection '${collectionName}' already exists.`);
  } catch (error) {
    if (error.httpStatus === 404) {
      console.log(`Creating Typesense collection for '${collectionName}'...`);
      const schema = {
        'name': collectionName,
        'fields': fields,
      };
      await typesense.collections().create(schema);
      console.log(`Typesense collection '${collectionName}' created.`);
    } else {
      throw error;
    }
  }
}

function listenToFirestoreAndSyncWithTypesense(firestoreCollectionName, typesenseCollectionName, dataFieldName) {
  const col = collection(db, firestoreCollectionName);

  onSnapshot(col, async (snapshot) => {
    await ensureTypesenseCollectionExists(typesenseCollectionName, [
      { 'name': 'id', 'type': 'string' },
      { 'name': dataFieldName, 'type': 'string' }
    ]);

    snapshot.docChanges().forEach((change) => {
      const docId = change.doc.id;
      const docData = change.doc.data();
      const dataToIndex = { id: docId, [dataFieldName]: docData[dataFieldName] };

      switch (change.type) {
        case 'added':
        case 'modified':
          indexDocumentInTypesense(typesenseCollectionName, docId, dataToIndex)
            .then(response => console.log(`Document ${change.type} in Typesense`, response))
            .catch(error => console.error(`Error indexing document ${docId}`, error));
          break;
        case 'removed':
          deleteDocumentFromTypesense(typesenseCollectionName, docId)
            .then(response => console.log(`Document removed from Typesense`, response))
            .catch(error => console.error(`Error deleting document ${docId}`, error));
          break;
        default:
          console.log(`Unhandled change type: ${change.type}`);
      }
    });
  });

  console.log(`Listening to Firestore collection '${firestoreCollectionName}' and syncing with Typesense collection '${typesenseCollectionName}'`);
}

function handleTypesenseSync(change) {
  const docId = change.doc.id;
  const docData = change.doc.data();
  const dataToIndex = { id: docId, headline: docData['headline'] };

  switch (change.type) { 
    case 'added':
    case 'modified':
      indexDocumentInTypesense('Discussions', docId, dataToIndex)
        .then(response => console.log(`Document ${change.type} in Typesense`, response))
        .catch(error => console.error(`Error indexing document ${docId}`, error));
      break;
    case 'removed':
      deleteDocumentFromTypesense('Discussions', docId)
        .then(response => console.log(`Document removed from Typesense`, response))
        .catch(error => console.error(`Error deleting document ${docId}`, error));
      break;
    default:
      console.log(`Unhandled change type: ${change.type}`);
  }
}

function listenToAllDiscussions() {
  const discussionsPostsQuery = collectionGroup(db, 'posts');

  onSnapshot(discussionsPostsQuery, (snapshot) => {
    ensureTypesenseCollectionExists('Discussions', [
      { 'name': 'id', 'type': 'string' },
      { 'name': 'headline', 'type': 'string' }
    ])
    snapshot.docChanges().forEach(handleTypesenseSync);
  });

  console.log(`Listening to all 'posts' subcollections across all 'discussions'`);
}

listenToFirestoreAndSyncWithTypesense('Users', 'Users', 'fullName');
listenToFirestoreAndSyncWithTypesense('discussions', 'Communities', 'name');
listenToAllDiscussions()