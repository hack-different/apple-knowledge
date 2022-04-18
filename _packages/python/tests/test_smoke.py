import apple_data


def test_smoke_test():
    data = apple_data.load_file('cores')
    assert data