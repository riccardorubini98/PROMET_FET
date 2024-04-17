#!/bin/bash

CMD='python'
SEED=0
SUBSET=0
while getopts "ds:k:" opt; do
  case $opt in
    d) CMD='debugpy-run -p :5708'
    ;;
    s) SEED=$OPTARG
    ;;
    k) SUBSET=$OPTARG
    ;;
  esac
done


DATACONFIG='configs/data/few_NERD_s'$SUBSET'.yaml'

CUDA_VISIBLE_DEVICES=1 $CMD trainers/trainer_alignie.py fit \
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
--trainer.max_epochs=30 \
--model configs/model/common.yaml \
--model configs/model/classifier_alignie.yaml \
--logger configs/logger.yaml \
--logger.project='PROMET_vs_ALIGNIE' \
--logger.name='ALIGNIE_30_epochs' \