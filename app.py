from flask import Flask, render_template, request
import logging
import os
import socket  # Módulo para obter informações do servidor
import psycopg2

app = Flask(__name__,
            static_url_path='',
            static_folder='static',
            template_folder='templates')

DB_CONFIG = {
    'host': os.environ.get('DB_HOST'),
    'port': os.environ.get('DB_PORT', '5432'),
    'dbname': os.environ.get('DB_NAME'),
    'user': os.environ.get('DB_USER'),
    'password': os.environ.get('DB_PASSWORD'),
    'sslmode': os.environ.get('DB_SSLMODE', 'require'),
}


def get_db_connection():
    return psycopg2.connect(**DB_CONFIG)


def init_db():
    if not DB_CONFIG['host']:
        return
    with get_db_connection() as conn:
        with conn.cursor() as cur:
            cur.execute("""
                CREATE TABLE IF NOT EXISTS conversoes (
                    id SERIAL PRIMARY KEY,
                    tipo_conversao INTEGER NOT NULL,
                    valor_entrada NUMERIC NOT NULL,
                    valor_convertido NUMERIC,
                    unidade VARCHAR(20),
                    criado_em TIMESTAMP DEFAULT NOW()
                )
            """)
        conn.commit()


def salvar_conversao(tipo, valor_entrada, valor_convertido, unidade):
    if not DB_CONFIG['host']:
        return
    try:
        with get_db_connection() as conn:
            with conn.cursor() as cur:
                cur.execute(
                    "INSERT INTO conversoes (tipo_conversao, valor_entrada, valor_convertido, unidade) "
                    "VALUES (%s, %s, %s, %s)",
                    (tipo, valor_entrada, valor_convertido, unidade)
                )
            conn.commit()
    except Exception as e:
        app.logger.warning(f"Falha ao salvar conversão no banco: {e}")


init_db()


@app.route('/', methods=['GET', 'POST'])
def index():
    # Obter informações do servidor
    hostname = socket.gethostname()
    ip_address = socket.gethostbyname(hostname)

    if request.method == 'GET':  
        return render_template('index.html', hostname=hostname, ip_address=ip_address)
    else:
        selecao = request.form.get('selectTemp')
        valor = request.form.get('valorRef')

        try:
            valor = float(valor)
        except ValueError:
            return render_template('index.html', conteudo={'unidade': 'inválido', 'valor': 'Entrada inválida'}, hostname=hostname, ip_address=ip_address)

        # Lógica de conversão
        if selecao == '1':  # Metro para Quilômetros
            resultado = valor / 1000
            unidade = "quilômetros"
        elif selecao == '2':  # Quilômetros para Metro
            resultado = valor * 1000
            unidade = "metros"
        elif selecao == '3':  # Metro para Milhas
            resultado = valor / 1609.34
            unidade = "milhas"
        elif selecao == '4':  # Milhas para Metro
            resultado = valor * 1609.34
            unidade = "metros"
        elif selecao == '5':  # Metro para Pés
            resultado = valor * 3.28084
            unidade = "pés"
        elif selecao == '6':  # Pés para Metro
            resultado = valor / 3.28084
            unidade = "metros"
        else:
            resultado = "Inválido"
            unidade = ""

        if isinstance(resultado, (int, float)):
            salvar_conversao(int(selecao), valor, resultado, unidade)

        return render_template('index.html', conteudo={'unidade': unidade, 'valor': resultado}, hostname=hostname, ip_address=ip_address)

if __name__ == '__main__':
    app.run()
else:
    gunicorn_logger = logging.getLogger('gunicorn.error')
    app.logger.handlers = gunicorn_logger.handlers
    app.logger.setLevel(gunicorn_logger.level)
