import os
import json
from qdrant_client import QdrantClient

def main():
    # Initialize Qdrant Client to point to our local docker service
    # The Qdrant service is exposed on localhost:6333 by docker-compose
    qdrant_url = os.getenv("QDRANT_URL", "http://localhost:6333")
    client = QdrantClient(url=qdrant_url)

    # Define the collection name
    COLLECTION_NAME = "security_playbooks"

    # Initialize fastembed in Qdrant (this will download the local embedding model)
    print("Setting up embedding model...")
    client.set_model("BAAI/bge-small-en-v1.5")

    # Load Playbooks
    playbook_file = os.path.join(os.path.dirname(os.path.abspath(__file__)), "playbooks.json")
    try:
        with open(playbook_file, "r", encoding="utf-8") as f:
            documents = json.load(f)
    except FileNotFoundError:
        print(f"Error: Playbook file not found at {playbook_file}")
        return

    print(f"Adding {len(documents)} documents to Qdrant collection '{COLLECTION_NAME}'...")

    docs = [doc["content"] for doc in documents]
    metadata = [{"title": doc["title"]} for doc in documents]
    ids = [doc["id"] for doc in documents]

    # Qdrant client's `add` method simplifies the process of embedding and indexing
    client.add(
        collection_name=COLLECTION_NAME,
        documents=docs,
        metadata=metadata,
        ids=ids
    )

    print("Ingestion complete! Data is ready for RAG.")

if __name__ == "__main__":
    main()
