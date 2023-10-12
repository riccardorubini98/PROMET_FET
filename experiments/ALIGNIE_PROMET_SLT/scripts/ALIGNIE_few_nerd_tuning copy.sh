#!/bin/bash

CMD='python'
SEED=0
SUBSET=0
LR=0.0001
LAMBDA=1
while getopts "ds:k:l:a:" opt; do
  case $opt in
    d) CMD='debugpy-run -p :5708'
    ;;
    s) SEED=$OPTARG
    ;;
    k) SUBSET=$OPTARG
    ;;
    l) LR=$OPTARG
    ;;
    a) LAMBDA=$OPTARG
    ;;
  esac
done


DATACONFIG='configs/data/few_NERD_s'$SUBSET'.yaml'

CUDA_VISIBLE_DEVICES=1 $CMD trainers/tuning_alignie.py fit \
--seed_everything=$SEED \
--data configs/data/common_alignie.yaml \
--data $DATACONFIG \
--trainer configs/trainer_common.yaml \
--trainer.callbacks=ModelCheckpoint \
--trainer.callbacks.dirpath= \
--trainer.callbacks.filename='ALIGNIE' \
--trainer.callbacks.monitor=val_main_loss \
--trainer.callbacks.mode=min \
--trainer.callbacks.save_weights_only=True \
--model configs/model/common.yaml \
--model configs/model/classifier_alignie.yaml \
--model.learning_rate=$LR \
--model.lambda_scale=$LAMBDA \
--logger configs/logger.yaml \
--logger.project='ALIGNIE_SINGLE_FEW_NERD_TUNING' \
--trainer.callbacks=EarlyStopping \
--trainer.callbacks.patience=5 \
--trainer.callbacks.monitor=val_main_loss \
--trainer.callbacks.mode=min \
--trainer.callbacks.verbose=True \