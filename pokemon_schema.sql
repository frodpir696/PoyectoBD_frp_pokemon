DROP DATABASE IF EXISTS pokemon;
CREATE DATABASE pokemon;

USE pokemon;

CREATE TABLE tipos (
  id_tipo INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL
);

CREATE TABLE entrenador (
  id_entrenador INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  ciudad VARCHAR(100),
  medallas_ganadas TINYINT UNSIGNED
);

CREATE TABLE objetos (
  id_objeto INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  tipo_objeto VARCHAR(50),
  efecto VARCHAR(100)
);

CREATE TABLE pokemon (
  id_pokemon INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  nivel TINYINT UNSIGNED NOT NULL,
  experiencia INT UNSIGNED NOT NULL,
  id_tipo_primario INT UNSIGNED,
  id_tipo_secundario INT UNSIGNED,
  id_entrenador INT UNSIGNED,
  id_objeto INT UNSIGNED,
  FOREIGN KEY (id_tipo_primario) REFERENCES tipos(id_tipo),
  FOREIGN KEY (id_tipo_secundario) REFERENCES tipos(id_tipo),
  FOREIGN KEY (id_entrenador) REFERENCES entrenador(id_entrenador),
  FOREIGN KEY (id_objeto) REFERENCES objetos(id_objeto)
);

CREATE TABLE movimientos (
  id_movimiento INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  tipo INT UNSIGNED NOT NULL,
  poder TINYINT UNSIGNED NOT NULL,
  precision_valor TINYINT UNSIGNED NOT NULL,  -- Nombre ajustado
  FOREIGN KEY (tipo) REFERENCES tipos(id_tipo)
);

CREATE TABLE pokemon_movimientos (
  id_pokemon INT UNSIGNED,
  id_movimiento INT UNSIGNED,
  PRIMARY KEY (id_pokemon, id_movimiento),
  FOREIGN KEY (id_pokemon) REFERENCES pokemon(id_pokemon),
  FOREIGN KEY (id_movimiento) REFERENCES movimientos(id_movimiento)
);

CREATE TABLE evoluciones (
  id_pokemon INT UNSIGNED,
  id_evolucion INT UNSIGNED,
  nivel_requerido TINYINT UNSIGNED,
  PRIMARY KEY (id_pokemon, id_evolucion),
  FOREIGN KEY (id_pokemon) REFERENCES pokemon(id_pokemon),
  FOREIGN KEY (id_evolucion) REFERENCES pokemon(id_pokemon)
);

CREATE TABLE batallas (
  id_batalla INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  id_entrenador1 INT UNSIGNED NOT NULL,
  id_entrenador2 INT UNSIGNED NOT NULL,
  ganador INT UNSIGNED,
  fecha DATE,
  FOREIGN KEY (id_entrenador1) REFERENCES entrenador(id_entrenador),
  FOREIGN KEY (id_entrenador2) REFERENCES entrenador(id_entrenador),
  FOREIGN KEY (ganador) REFERENCES entrenador(id_entrenador)
);

CREATE TABLE batallas_detalle (
  id_batalla INT UNSIGNED,
  id_pokemon INT UNSIGNED,
  id_movimiento INT UNSIGNED,
  resultado VARCHAR(50),
  PRIMARY KEY (id_batalla, id_pokemon),
  FOREIGN KEY (id_batalla) REFERENCES batallas(id_batalla),
  FOREIGN KEY (id_pokemon) REFERENCES pokemon(id_pokemon),
  FOREIGN KEY (id_movimiento) REFERENCES movimientos(id_movimiento)
);
