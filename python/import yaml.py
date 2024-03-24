import yaml

with open('original_config.yaml', 'r') as file:
    original_config = yaml.load(file, Loader=yaml.FullLoader)

def generate_new_yaml_config(original_config):
    # New values list initialized with the predefined value
    new_values = ["predefinedOtherValue"]
    
    for key in original_config.keys():
        # Append the key (endpoint name) to the new values list
        new_values.append(key)
    
    new_config = {
        "new_yaml_config": new_values
    }

    with open("new_config.yaml", "w") as new_config_file:
        yaml.dump(new_config, new_config_file, default_flow_style=False)

generate_new_yaml_config(original_config)
