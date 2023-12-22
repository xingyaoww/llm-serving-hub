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
