from pathlib import Path

from langchain_text_splitters import RecursiveCharacterTextSplitter
from langchain_huggingface import HuggingFaceEmbeddings
from langchain_chroma import Chroma


# Location where ChromaDB will store our vector data
CHROMA_DIR = Path("chroma_db")


# Create the embedding model
embeddings = HuggingFaceEmbeddings(
    model_name="sentence-transformers/all-MiniLM-L6-v2"
)


def build_vector_store(text: str):
    """
    Convert resume text into chunks, create embeddings,
    and store them inside ChromaDB.
    """

    if not text or not text.strip():
        raise ValueError("Resume text is empty.")

    # 1. Split resume into smaller chunks
    text_splitter = RecursiveCharacterTextSplitter(
        chunk_size=500,
        chunk_overlap=50
    )

    chunks = text_splitter.split_text(text)

    print(f"Created {len(chunks)} text chunks.")

    # 2. Store chunks and their embeddings in ChromaDB
    vector_store = Chroma.from_texts(
        texts=chunks,
        embedding=embeddings,
        persist_directory=str(CHROMA_DIR),
        collection_name="resume_documents"
    )

    print("Resume embeddings stored in ChromaDB.")

    return vector_store

def retrieve_context(query: str, k: int = 4):
    """
    Retrieve the most relevant resume chunks from ChromaDB
    based on the user's query.
    """

    if not CHROMA_DIR.exists():
        return "No resume has been uploaded yet."

    vector_store = Chroma(
        collection_name="resume_documents",
        embedding_function=embeddings,
        persist_directory=str(CHROMA_DIR)
    )

    documents = vector_store.similarity_search(query, k=k)

    if not documents:
        return "No relevant information found in the resume."

    context = "\n\n".join(
        document.page_content for document in documents
    )

    return context