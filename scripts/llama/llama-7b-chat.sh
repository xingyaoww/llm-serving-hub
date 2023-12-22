#!/bin/bash

source scripts/source.sh


# MODEL_PATH, MAX_INPUT_LENGTH, MAX_TOTAL_TOKENS (need for TGI)
tgi_serve_model_docker /data/shared/Llama-2-70b-chat-hf 3968 4096

