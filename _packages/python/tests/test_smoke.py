import apple_data


def test_smoke_test():
    data = apple_data.load_file('cores')
    assert data


def test_url_naked():
    url = apple_data.get_url('cores')
    assert url == 'https://docs.hackdiff.rent/.data/cores.json'

def test_url_yaml():
    url = apple_data.get_url('cores', 'yaml')
    assert url == 'https://docs.hackdiff.rent/.data/cores.yaml'