-- phpMyAdmin SQL Dump
-- version 4.9.5deb2
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost:3306
-- Tiempo de generación: 04-01-2021 a las 17:19:27
-- Versión del servidor: 8.0.22-0ubuntu0.20.04.3
-- Versión de PHP: 7.4.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `COVID19_JSP`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `AsignacionRol`
--

CREATE TABLE `AsignacionRol` (
  `idRol` int NOT NULL,
  `DNI` varchar(9) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `AsignacionRol`
--

INSERT INTO `AsignacionRol` (`idRol`, `DNI`) VALUES
(2, '00000000A'),
(2, '05982239P'),
(1, '88888888M');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `InfeccionSemanal`
--

CREATE TABLE `InfeccionSemanal` (
  `idSemana` int NOT NULL,
  `idRegion` int NOT NULL,
  `NumInfectados` int NOT NULL,
  `NumFallecidos` int NOT NULL,
  `NumAltas` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `InfeccionSemanal`
--

INSERT INTO `InfeccionSemanal` (`idSemana`, `idRegion`, `NumInfectados`, `NumFallecidos`, `NumAltas`) VALUES
(1, 1, 1000, 20, 100),
(1, 2, 40000, 10000, 10),
(2, 1, 100, 20, 10);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Region`
--

CREATE TABLE `Region` (
  `idRegion` int NOT NULL,
  `Nombre` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `Region`
--

INSERT INTO `Region` (`idRegion`, `Nombre`) VALUES
(1, 'Castilla-La Mancha'),
(2, 'Madrid'),
(3, 'Extremadura'),
(4, 'Andalucía'),
(5, 'Murcia');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Rol`
--

CREATE TABLE `Rol` (
  `idRol` int NOT NULL,
  `Rol` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `Rol`
--

INSERT INTO `Rol` (`idRol`, `Rol`) VALUES
(1, 'Gestor'),
(2, 'Administrador / Gestor');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Semana`
--

CREATE TABLE `Semana` (
  `idSemana` int NOT NULL,
  `Semana` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `Semana`
--

INSERT INTO `Semana` (`idSemana`, `Semana`) VALUES
(1, 'Semana 1'),
(2, 'Semana 2'),
(4, 'Semana 3');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Usuario`
--

CREATE TABLE `Usuario` (
  `Nombre` varchar(50) NOT NULL,
  `Apellidos` varchar(50) NOT NULL,
  `DNI` varchar(9) NOT NULL,
  `Correo` varchar(50) NOT NULL,
  `Contra` varchar(50) NOT NULL,
  `Activado` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `Usuario`
--

INSERT INTO `Usuario` (`Nombre`, `Apellidos`, `DNI`, `Correo`, `Contra`, `Activado`) VALUES
('Admin', 'Admin', '00000000A', 'admin@admin.com', 'Admin1234', 1),
('Alejandro', 'Martin Perez', '05982239P', 'alejandro.martin.perez.99@gmail.com', 'Alejandro1234', 1),
('Maki', 'Navaja', '88888888M', 'makina@gmail.com', 'Makina1234', 1);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `InfeccionSemanal`
--
ALTER TABLE `InfeccionSemanal`
  ADD PRIMARY KEY (`idSemana`,`idRegion`);

--
-- Indices de la tabla `Region`
--
ALTER TABLE `Region`
  ADD PRIMARY KEY (`idRegion`);

--
-- Indices de la tabla `Semana`
--
ALTER TABLE `Semana`
  ADD PRIMARY KEY (`idSemana`);

--
-- Indices de la tabla `Usuario`
--
ALTER TABLE `Usuario`
  ADD PRIMARY KEY (`DNI`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `Region`
--
ALTER TABLE `Region`
  MODIFY `idRegion` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de la tabla `Semana`
--
ALTER TABLE `Semana`
  MODIFY `idSemana` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
