from app import converter, app as flask_app


def test_metro_para_quilometros():
    resultado, unidade = converter('1', 1000)
    assert resultado == 1
    assert unidade == "quilômetros"


def test_quilometros_para_metro():
    resultado, unidade = converter('2', 1)
    assert resultado == 1000
    assert unidade == "metros"


def test_metro_para_milhas():
    resultado, unidade = converter('3', 1609.34)
    assert round(resultado, 2) == 1.0
    assert unidade == "milhas"


def test_milhas_para_metro():
    resultado, unidade = converter('4', 1)
    assert round(resultado, 2) == 1609.34
    assert unidade == "metros"


def test_metro_para_pes():
    resultado, unidade = converter('5', 1)
    assert round(resultado, 5) == 3.28084
    assert unidade == "pés"


def test_pes_para_metro():
    resultado, unidade = converter('6', 3.28084)
    assert round(resultado, 2) == 1.0
    assert unidade == "metros"


def test_opcao_invalida():
    resultado, unidade = converter('99', 10)
    assert resultado == "Inválido"
    assert unidade == ""


def test_pagina_inicial_responde():
    client = flask_app.test_client()
    response = client.get('/')
    assert response.status_code == 200


def test_conversao_via_formulario():
    client = flask_app.test_client()
    response = client.post('/', data={'selectTemp': '1', 'valorRef': '1000'})
    assert response.status_code == 200
    assert "quilômetros" in response.get_data(as_text=True)


def test_entrada_invalida_via_formulario():
    client = flask_app.test_client()
    response = client.post('/', data={'selectTemp': '1', 'valorRef': 'abc'})
    assert response.status_code == 200
    assert "inválido" in response.get_data(as_text=True).lower()
