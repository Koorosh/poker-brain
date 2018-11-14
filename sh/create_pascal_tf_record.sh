#!/usr/bin/env bash
# move to README.md
python /sh/create_pascal_tf_record.py \
    --label_map_path=/data/poker_label_map.pbtxt \
    --data_dir=/images/POKER20181113 \
    --year=Poker2018 \
    --set=train \
    --output_path=/data/poker_train.record

python /sh/create_pascal_tf_record.py \
    --label_map_path=/data/poker_label_map.pbtxt \
    --data_dir=/images/POKER20181113 \
    --year=Poker2018 \
    --set=val \
    --output_path=/data/poker_val.record


# From the tensorflow/models/research/ directory
PIPELINE_CONFIG_PATH=/models/2018-11-13_ssdlite_mobilenet_v2/ssdlite_mobilenet_v2_coco.config
MODEL_DIR=/models/2018-11-13_ssdlite_mobilenet_v2
NUM_TRAIN_STEPS=50000
SAMPLE_1_OF_N_EVAL_EXAMPLES=1
python object_detection/model_main.py \
    --pipeline_config_path=${PIPELINE_CONFIG_PATH} \
    --model_dir=${MODEL_DIR} \
    --num_train_steps=${NUM_TRAIN_STEPS} \
    --sample_1_of_n_eval_examples=$SAMPLE_1_OF_N_EVAL_EXAMPLES \
    --alsologtostderr