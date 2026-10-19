from datetime import time as dt_time

from django.apps import AppConfig
from django.db.backends.signals import connection_created
from psycopg.adapt import Loader


def load_postgres_time(data):
    """Load a PostgreSQL time value.

    PostgreSQL accepts ``24:00:00`` (end of day). Python ``datetime.time``
    does not, so that value is returned as the string ``24:00:00``.
    """
    if isinstance(data, memoryview):
        raw = data.tobytes()
    elif isinstance(data, str):
        raw = data.encode()
    else:
        raw = bytes(data)

    text = raw.decode('ascii')
    clock, _, frac = text.partition('.')
    hour_s, minute_s, second_s = clock.split(':')
    hour = int(hour_s)
    minute = int(minute_s)
    second = int(second_s)
    microsecond = int((frac + '000000')[:6]) if frac else 0

    if hour == 24 and minute == 0 and second == 0 and microsecond == 0:
        return '24:00:00'
    if hour == 24:
        hour = 0

    return dt_time(hour, minute, second, microsecond)


class PostgresTimeLoader(Loader):
    def load(self, data):
        return load_postgres_time(data)


def register_postgres_time_loader(sender, connection, **kwargs):
    if connection.vendor != 'postgresql':
        return
    pg_connection = getattr(connection, 'connection', None)
    if pg_connection is None or not hasattr(pg_connection, 'adapters'):
        return
    pg_connection.adapters.register_loader('time', PostgresTimeLoader)


class AppLfItseConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'app_lf_itse'

    def ready(self):
        connection_created.connect(
            register_postgres_time_loader,
            dispatch_uid='app_lf_itse.register_postgres_time_loader',
        )
