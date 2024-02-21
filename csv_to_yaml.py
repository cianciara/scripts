import csv
import yaml

csv_file_path = 'example_data.csv'
data_structure = {}

with open(csv_file_path, mode='r') as csv_file:
    csv_reader = csv.DictReader(csv_file)
    for row in csv_reader:
        member_id = row['member_id']
        data_structure[member_id] = {
            'host': row['host'],
            'port': row['port'],
            'info': {
                'role': row['role'],
                'name': row['short_name']
            }
        }

yaml_data = yaml.dump(data_structure, sort_keys=False, allow_unicode=True)

yaml_file_path = 'output.yaml'
with open(yaml_file_path, 'w') as yaml_file:
    yaml_file.write(yaml_data)