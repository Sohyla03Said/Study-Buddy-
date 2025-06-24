from huggingface_hub import hf_hub_download
import os

def download_mistral_model():
    """Download Mistral-7B Instruct v0.2 Q4_K_M model."""
    os.makedirs("models", exist_ok=True)
    print("Downloading Mistral-7B model... This may take a while.")
    model_path = hf_hub_download(
        repo_id="TheBloke/Mistral-7B-Instruct-v0.2-GGUF",
        filename="mistral-7b-instruct-v0.2.Q4_K_M.gguf",
        local_dir="models/"
    )
    print(f"Model downloaded successfully to: {model_path}")
    return model_path

if __name__ == "__main__":
    download_mistral_model()