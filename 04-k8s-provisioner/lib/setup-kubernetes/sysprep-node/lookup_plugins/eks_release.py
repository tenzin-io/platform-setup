from ansible.plugins.lookup import LookupBase
import requests
import yaml

def load_yaml_from_url(url):
    try:
        response = requests.get(url)
        response.raise_for_status()
        yaml_data = yaml.safe_load(response.text)
        return yaml_data
    except requests.exceptions.RequestException as e:
        print(f"Error downloading or parsing YAML from URL: {e}")
        return None
    except yaml.YAMLError as e:
        print(f"Error parsing YAML content: {e}")
        return None

def find_eks_binary_uri(yaml_data, binary, arch="amd64", os="linux"):
    kubernetes_component = [
        component
        for component in yaml_data['status']['components']
        if component['name'] == "kubernetes"
    ][0]

    kubernetes_asset = [
        asset
        for asset in kubernetes_component["assets"]
        if asset['name'] == f"bin/{os}/{arch}/{binary}"
    ][0]

    return kubernetes_asset['archive']['uri']


class LookupModule(LookupBase):
    def run(self, terms, variables=None, **kwargs):
        binary, arch, os = terms

        eks_release_url = variables.get('eks_release_url', None)
        if eks_release_url is None:
            raise ValueError("The 'eks_release_url' is required but not provided.")

        yaml_data = load_yaml_from_url(eks_release_url)
        return [find_eks_binary_uri(yaml_data, binary, arch, os)]
