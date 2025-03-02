import firebase_admin
from firebase_admin import credentials, firestore

# Inicializa Firebase Admin SDK
cred = credentials.Certificate('serviceAccountKey.json')  # Asegúrate de que la ruta sea correcta
firebase_admin.initialize_app(cred)

db = firestore.client()

def update_documents():
    try:
        # Obtén todos los documentos de la colección
        docs = db.collection('taxones').stream()

        for doc in docs:
            data = doc.to_dict()

            # Si el documento no tiene el campo userId, lo añadimos
            if 'userId' not in data:
                doc.reference.update({
                    'userId': 'eN8NEslTVwOELFCkNBIophANqXr1'  # Reemplaza con el UID del usuario correspondiente
                })
                print(f'Documento {doc.id} actualizado.')

        print('Todos los documentos han sido actualizados.')
    except Exception as e:
        print(f'Error actualizando documentos: {e}')

update_documents()