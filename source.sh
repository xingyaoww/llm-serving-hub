#!/bin/bash

DOCKER_IMG="ghcr.io/huggingface/text-generation-inference:1.3"
echo "Using CUDA_VISIBLE_DEVICES=$CUDA_VISIBLE_DEVICES"

tgi_serve_model_docker() {
    FULL_PATH=$1
    MAX_INPUT_LENGTH=$2
    MAX_TOTAL_TOKENS=$3
    MODEL_DIR=$(dirname "$FULL_PATH")
    MODEL_NAME=$(basename "$FULL_PATH")
    echo "Serving model $MODEL_NAME from $MODEL_DIR"

    docker run \
        -e CUDA_VISIBLE_DEVICES=$CUDA_VISIBLE_DEVICES \
        --gpus all \
        -p 8080:80 \
        -v $MODEL_DIR:/data \
        $DOCKER_IMG \
        --model-id /data/$MODEL_NAME \
        --hostname 0.0.0.0 \
        --max-batch-prefill-tokens $MAX_INPUT_LENGTH \
        --max-input-length $MAX_INPUT_LENGTH \
        --max-total-tokens $MAX_TOTAL_TOKENS \
        ${@:4}
    
    echo "Model $MODEL_NAME is served with TGI using GPU $CUDA_VISIBLE_DEVICES on http://localhost:8080"
}


vllm_serve_model_docker() {
    FULL_PATH=$1
    MAX_TOTAL_TOKENS=$2
    CHAT_TEMPLATE=$3
    MODEL_DIR=$(dirname "$FULL_PATH")
    MODEL_NAME=$(basename "$FULL_PATH")
    echo "Serving model $MODEL_NAME from $MODEL_DIR"

    docker run \
        -e CUDA_VISIBLE_DEVICES=$CUDA_VISIBLE_DEVICES \
        --runtime nvidia --gpus all \
        -v $MODEL_DIR:/data \
        -v `pwd`:/workspace \
        -p 8000:8000 \
        --ipc=host \
        vllm/vllm-openai:latest \
        --model /data/$MODEL_NAME \
        --served-model-name $MODEL_NAME \
        --max-num-batched-tokens $MAX_TOTAL_TOKENS \
        --chat-template /workspace/$CHAT_TEMPLATE \

    echo "Model $MODEL_NAME is served with vLLM using GPU $CUDA_VISIBLE_DEVICES on http://localhost:8080"
}


vllm_serve_model() {
    FULL_PATH=$1
    MAX_TOTAL_TOKENS=$2
    CHAT_TEMPLATE=$3
    MODEL_DIR=$(dirname "$FULL_PATH")
    MODEL_NAME=$(basename "$FULL_PATH")
    echo "Serving model $MODEL_NAME from $MODEL_DIR"

    python3 -m vllm.entrypoints.openai.api_server \
        --model $FULL_PATH \
        --served-model-name $MODEL_NAME \
        --max-num-batched-tokens $MAX_TOTAL_TOKENS \
        --chat-template $CHAT_TEMPLATE \

    echo "Model $MODEL_NAME is served with vLLM using GPU $CUDA_VISIBLE_DEVICES on http://localhost:8080"
}
