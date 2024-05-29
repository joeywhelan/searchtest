
from redis import Redis, from_url
from time import perf_counter_ns, sleep
from redis.commands.search.field import TagField, NumericField, TextField
from redis.commands.search.indexDefinition import IndexDefinition, IndexType

def index_time(client:Redis) -> int:
    info = client.ft('idx').info()
    start = perf_counter_ns()
    while (float(info['percent_indexed']) < 1):
        sleep(0.1) #100 ms
        info = client.ft('idx').info()
    stop = perf_counter_ns()
    return (round((stop-start)/1000000,2))

if __name__ == '__main__':
    client:Redis = from_url('redis://localhost:12000')
    
    try:
        client.ft('idx').dropindex()
    except:
        pass
    idx_def = IndexDefinition(index_type=IndexType.JSON, prefix=['key:'])
    schema = [
        NumericField('$.num', as_name='num'),
        TextField('$.quote', as_name='quote')
    ]
    client.ft('idx').create_index(schema, definition=idx_def)
    print('*** FT.CREATE - 2 fields (NUMERIC, TEXT), 10M JSON docs ***')
    elapsed = index_time(client)
    print(f'Elapsed time: {elapsed} ms')

    client.ft('idx').alter_schema_add([TagField('$.color', as_name='color')])
    print('\n*** FT.ALTER - 1 field (TAG), 10M JSON docs ***')
    elapsed = index_time(client)
    print(f'Elapsed time: {elapsed} ms')
