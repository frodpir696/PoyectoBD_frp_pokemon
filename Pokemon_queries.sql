-- 5. Consultas SQL

-- Consulta simple (WHERE): Obtener Pokémon de tipo "Fuego"
SELECT nombre FROM pokemon  
WHERE id_tipo_primario = 1;

-- Consulta con múltiples tablas: Mostrar los nombres de los entrenadores y sus Pokémon asociados
SELECT entrenador.nombre AS Entrenador, pokemon.nombre AS Pokemon  
FROM entrenador  
JOIN pokemon ON entrenador.id_entrenador = pokemon.id_entrenador;

-- Consulta con agrupación: Contar la cantidad de Pokémon por tipo
SELECT tipos.nombre, COUNT(pokemon.id_pokemon)  
FROM pokemon  
JOIN tipos ON pokemon.id_tipo_primario = tipos.id_tipo  
GROUP BY tipos.nombre;

-- Consulta con subconsulta: Obtener Pokémon con nivel superior al promedio
SELECT nombre FROM pokemon  
WHERE nivel > (SELECT AVG(nivel) FROM pokemon);

-- Consulta combinada: Obtener entrenadores con más de 1 Pokémon
SELECT entrenador.nombre, COUNT(pokemon.id_pokemon) AS TotalPokemon  
FROM entrenador  
JOIN pokemon ON entrenador.id_entrenador = pokemon.id_entrenador  
GROUP BY entrenador.nombre  
HAVING COUNT(pokemon.id_pokemon) > 1;

-- 6. Vistas 

-- Vista de Entrenadores y sus Pokémon:

CREATE VIEW Entrenadores_Pokemon AS
SELECT entrenador.nombre AS Entrenador, pokemon.nombre AS Pokemon
FROM entrenador
JOIN pokemon ON entrenador.id_entrenador = pokemon.id_entrenador;

-- Vista de Cantidad de Pokémon por Tipo:

CREATE VIEW Pokemon_Por_Tipo AS
SELECT tipos.nombre, COUNT(pokemon.id_pokemon) AS Cantidad
FROM pokemon
JOIN tipos ON pokemon.id_tipo_primario = tipos.id_tipo
GROUP BY tipos.nombre;

-- 7. Funciones y Procedimientos

-- Función para Obtener el Nivel Promedio de Pokémon:

DELIMITER //
CREATE FUNCTION NivelPromedioPokemon() RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(10, 2);
    SELECT AVG(nivel) INTO promedio FROM pokemon;
    RETURN promedio;
END //
DELIMITER ;

SELECT NivelPromedioPokemon();

-- Función para Contar Pokémon por Tipo

DELIMITER //
CREATE FUNCTION CantidadPokemonPorTipo(nombre_tipo VARCHAR(50)) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE cantidad INT;
    SELECT COUNT(pokemon.id_pokemon) INTO cantidad
    FROM pokemon
    JOIN tipos ON pokemon.id_tipo_primario = tipos.id_tipo
    WHERE tipos.nombre = nombre_tipo;
    RETURN cantidad;
END //
DELIMITER ;

SELECT CantidadPokemonPorTipo("Hada");

-- Procedimiento para Mostrar Entrenadores con Más de 1 Pokémon

DELIMITER //
CREATE PROCEDURE EntrenadoresConMasDeUnPokemon()
BEGIN
    SELECT entrenador.nombre, COUNT(pokemon.id_pokemon) AS TotalPokemon
    FROM entrenador
    JOIN pokemon ON entrenador.id_entrenador = pokemon.id_entrenador
    GROUP BY entrenador.nombre
    HAVING COUNT(pokemon.id_pokemon) > 1;
END //
DELIMITER ;

CALL EntrenadoresConMasDeUnPokemon();

-- Procedimiento para Mostrar Pokémon de un Tipo Específico

DELIMITER //
CREATE PROCEDURE MostrarPokemonPorTipo(IN nombre_tipo VARCHAR(50))
BEGIN
    SELECT nombre FROM pokemon
    WHERE id_tipo_primario = (SELECT id_tipo FROM tipos WHERE nombre = nombre_tipo);
END //
DELIMITER ;

CALL MostrarPokemonPorTipo("Dragon");

-- Procedimiento para Mostrar Pokémon con Nivel Superior al Promedio

DELIMITER //
CREATE PROCEDURE MostrarPokemonNivelSuperiorPromedio()
BEGIN
    SELECT nombre FROM pokemon
    WHERE nivel > NivelPromedioPokemon();
END //
DELIMITER ;

CALL MostrarPokemonNivelSuperiorPromedio();

-- Trigger 

-- Trigger para Actualizar el Nivel de un Pokémon Después de una Batalla

DELIMITER //
CREATE TRIGGER ActualizarNivelPokemon
AFTER INSERT ON batallas_detalle
FOR EACH ROW
BEGIN
    IF NEW.resultado = 'Vencedor' THEN
        UPDATE pokemon SET nivel = nivel + 1 WHERE id_pokemon = NEW.id_pokemon;
    END IF;
END //
DELIMITER ;

-- Prueba
INSERT INTO batallas_detalle (id_batalla, id_pokemon, id_movimiento, resultado) VALUES (1, 120, 1, 'Vencedor');

-- Trigger para Registrar la Experiencia de un Pokémon Después de una Batalla

DELIMITER //
CREATE TRIGGER RegistrarExperienciaPokemon
AFTER INSERT ON batallas_detalle
FOR EACH ROW
BEGIN
    IF NEW.resultado = 'Vencedor' THEN
        UPDATE pokemon SET experiencia = experiencia + 200 WHERE id_pokemon = NEW.id_pokemon;
    ELSE
        UPDATE pokemon SET experiencia = experiencia + 50 WHERE id_pokemon = NEW.id_pokemon;
    END IF;
END //
DELIMITER ;

-- Prueba
INSERT INTO batallas_detalle (id_batalla, id_pokemon, id_movimiento, resultado) 
VALUES 
(51, 67, 1, 'Vencedor'),
(51, 68, 3, 'Derrotado');