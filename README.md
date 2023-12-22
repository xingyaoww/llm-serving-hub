## Installation

```bash
# Install litellm
conda create -n llm-serve python=3.10
conda activate llm-serve
pip install vllm
pip install 'litellm[proxy]'
```

Also install all dependencies for [TGI](https://github.com/huggingface/text-generation-inference).

If `docker` is available, you only need it!

## Start LiteLLM Proxy

```bash
litellm --config config.yml --port 8000
```

## Start TGI

```bash
export CUDA_VISIBLE_DEVICES="2,3";
source source.sh

# MODEL_PATH, MAX_INPUT_LENGTH, MAX_TOTAL_TOKENS (need for TGI)
tgi_serve_model_docker /data/shared/Llama-2-70b-chat-hf 3968 4096
tgi_serve_model_docker /data/shared/CodeLlama-34b-Instruct-hf 16256 16384

# MODEL_PATH, MAX_TOTAL_TOKENS, CHAT_TEMPLATE
vllm_serve_model_docker /data/shared/CodeLlama-34b-Instruct-hf/ 16384 chat_templates/llama.jinja
```
