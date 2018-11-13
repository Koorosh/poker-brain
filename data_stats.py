from os import listdir
from os.path import isfile, join
import xml.etree.ElementTree as ET
import pandas as pd
import numpy as np


def parse_xml(file_name):
    tree = ET.parse(file_name)
    return tree.getroot()


def get_stats_per_xml(xml_root_data):
    def add_class_to_stats(acc, child):
        class_name = child.find('name').text
        acc[class_name] = acc.get(class_name, 0) + 1
        return acc

    return reduce(add_class_to_stats, xml_root_data.findall('object'), dict())


def get_stats(files_stats):
    data_frame = pd.DataFrame.from_dict(files_stats).fillna(0).astype(np.int16, errors='ignore')
    return data_frame


def get_files_from_dir(root_dir):
    xml_files = [f for f in listdir(root_dir) if isfile(join(root_dir, f)) and f.endswith('.xml')]
    stats = []
    for xml_file in xml_files:
        xml_root = parse_xml('/'.join([root_dir, xml_file]))
        categories_per_file = get_stats_per_xml(xml_root)
        file_stats = {'file_name': xml_file}
        file_stats.update(categories_per_file)
        stats.append(file_stats)
    return stats


stats = get_files_from_dir('/Users/avor/projects/koorosh/poker-brain/datasets/PokerSet/Poker2018/Annotations')
stats_1 = get_stats(stats)
print(stats_1)
