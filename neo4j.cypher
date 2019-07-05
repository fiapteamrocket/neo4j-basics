//FIAP: 6IA - Carlos Martinelli, Jonatas Bertolazzo, Letticia Nicoli e Renato Ramos

// Cenário: Um motoboy irá realizar algumas entregas em 5 casas diferentes e gostaria de ter algumas informações sobre os caminhos e distâncias entre os locais de entrega.

CREATE
  (a:House {name: 'A'}),
  (b:House {name: 'B'}),
  (c:House {name: 'C'}),
  (d:House {name: 'D'}),
  (e:House {name: 'E'}),
  (a)-[:PATH_TO {distance : 3 }]->(b),
  (b)-[:PATH_TO {distance : 4 }]->(c),
  (c)-[:PATH_TO {distance : 12 }]->(d),
  (d)-[:PATH_TO {distance : 12 }]->(c),
  (d)-[:PATH_TO {distance : 6 }]->(e),
  (a)-[:PATH_TO {distance : 7 }]->(d),
  (c)-[:PATH_TO {distance : 9 }]->(e),
  (e)-[:PATH_TO {distance : 4 }]->(b),
  (a)-[:PATH_TO {distance : 6 }]->(e)
  
// Distância total utilizando o caminho A > B > C  
MATCH(a:House { name: 'A' })-[r:PATH_TO]->(b:House { name: 'B' })-[r2:PATH_TO]->(c:House { name: 'C' })
return r.distance + r2.distance

// Distância total entre A e D
MATCH(:House { name: 'A' })-[r:PATH_TO]->(:House { name: 'D' })
return r.distance

// Distância total utilizando o caminho A > D > C  
MATCH(a:House { name: 'A' })-[r:PATH_TO]->(d:House { name: 'D' })
        -[r2:PATH_TO]->(c:House { name: 'C' })
return r.distance + r2.distance

// Distância total utilizando o caminho A > B > C > D > E 
MATCH(a:House { name: 'A' })-[r:PATH_TO]->(e:House { name: 'E' })-[r2:PATH_TO]->(b:House { name: 'B' })
-[r3:PATH_TO]->(c:House { name: 'C' })-[r4:PATH_TO]->(d:House { name: 'D' })
return r.distance + r2.distance + r3.distance + r4.distance

// Distância total utilizando o caminho A > E > D
MATCH(:House { name: 'A' })-[r:PATH_TO]->(:House { name: 'E' })-[r2:PATH_TO]->(:House { name: 'D' })
return r.distance + r2.distance
//Obs.: esse caminho não existe

// Caminhos com 3 paradas ou menos
MATCH(:House { name: 'C' })-[r:PATH_TO*..3]->(:House { name: 'C' })
return count(r)

// Todos os caminhos entre os pontos A e C, com exatamente 4 paradas
MATCH (start:House { name: 'A' }), (end:House { name: 'C' })
CALL apoc.path.expandConfig(start, {endNodes:[end], minLevel:4, maxLevel:4, relationshipFilter:'PATH_TO>', uniqueness:'NONE'}) YIELD path
RETURN [node in nodes(path) | node.name] as path

// Para execução do script abaixo é necessário instalar o pluglin APOC
// Caminho mais curto utilizando dijkstra entre A e C, considerando a distância
MATCH (start:House {name: 'A'}), (end:House {name: 'C'})
CALL apoc.algo.dijkstra(start, end, 'PATH_TO', 'distance') YIELD path, weight
RETURN path, weight

// Excluir todos os nós e relacionamentos 
MATCH (House)
DETACH DELETE House