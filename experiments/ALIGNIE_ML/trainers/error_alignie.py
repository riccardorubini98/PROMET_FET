from entity_typing_framework.dataset_classes.dataset_managers import ALIGNIEDatasetManager, DatasetManager, IncrementalDatasetManagerWithTestLog
from entity_typing_framework.main_module.custom_logger import CustomLogger
from entity_typing_framework.main_module.main_module import ALIGNIEMainModule, CrossDatasetMainModule, IncrementalMainModule
from entity_typing_framework.main_module.inference_manager import ThresholdOrMaxInferenceManager
from pytorch_lightning.utilities.cli import LightningCLI
from entity_typing_framework.utils.trainer import trainer_utils
import torch
import pandas as pd
from tqdm import tqdm

def dummy_compute_fn(arg):
    return arg

class MyLightningCLI(LightningCLI):
    def add_arguments_to_parser(self, parser):
        parser.add_lightning_class_args(CustomLogger, "logger")

        parser.link_arguments("data.type_number", "model.type_number", apply_on="instantiate")
        parser.link_arguments("data.type2id", "model.type2id", apply_on="instantiate")
        parser.link_arguments("data.mask_token_id", "model.mask_token_id", apply_on="instantiate")
        parser.link_arguments("data.verbalizer", "model.verbalizer", apply_on="instantiate")
        parser.link_arguments("logger", "model.logger", apply_on="instantiate", compute_fn = dummy_compute_fn)

cli = MyLightningCLI(ALIGNIEMainModule, ALIGNIEDatasetManager, save_config_overwrite=True)
# load best model
cli.trainer.model.ET_Network = cli.trainer.model.load_ET_Network(checkpoint_to_load=cli.trainer.checkpoint_callback.best_model_path, ET_Network_params = cli.trainer.model.ET_Network_params)

# calibrate threshold
# trainer_utils.calibrate_threshold(cli.trainer, 0.01, 'dev/macro_example/f1', incremental=False)

# test step
text = []
pred_labels = []
true_labels = []
type2id=cli.trainer.model.type2id
id2type={k:v for v,k in type2id.items()}
inference = ThresholdOrMaxInferenceManager(name='inf',type2id=type2id)
test_loader = cli.trainer.datamodule.test_dataloader()
tokenizer = cli.trainer.model.tokenizer
cli.trainer.model.to('cuda')
cli.trainer.model.eval()
with torch.no_grad():
    for input_ids, attention_mask, true_label in tqdm(test_loader):
        input_ids, attention_mask, true_label = input_ids.to('cuda'), attention_mask.to('cuda'), true_label.to('cuda')
        score, true_label = cli.trainer.model.ET_Network([input_ids, attention_mask, true_label])
        prob = torch.sigmoid(score[0])
        pred = inference.discretize_output(prob)
        for ex in pred:
            labels = []
            pred_ids = torch.argwhere(ex==1).flatten().tolist()
            for pred_id in pred_ids:
                labels.append(id2type[pred_id])
            pred_labels.append(labels)
        for ex in true_label:
            labels = []
            true_ids = torch.argwhere(ex==1).flatten().tolist()
            for true_id in true_ids:
                labels.append(id2type[true_id])
            true_labels.append(labels)
        for ex_ids in input_ids:
            text.append(tokenizer.decode(ex_ids, skip_special_tokens=True))
df = pd.DataFrame({'text':text, 'pred_labels':pred_labels, 'true_labels':true_labels})
df.to_csv('alignie_test.csv')
x=0