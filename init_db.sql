-- ---
-- Globals
-- ---

-- SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
-- SET FOREIGN_KEY_CHECKS=0;

-- ---
-- Table 'Alumno'
-- 
-- ---

DROP TABLE IF EXISTS `Alumno`;
		
CREATE TABLE `Alumno` (
  `matrícula` VARCHAR(7) NOT NULL DEFAULT 'NULL',
  `nombre` VARCHAR(30) NOT NULL DEFAULT 'NULL',
  `apellidoPaterno` VARCHAR(30) NOT NULL DEFAULT 'NULL',
  `apellidoMaterno` VARCHAR(30) NOT NULL DEFAULT 'NULL',
  `matrícula_Responde` INTEGER NULL DEFAULT NULL,
  PRIMARY KEY (`matrícula`)
);

-- ---
-- Table 'Pregunta'
-- 
-- ---

DROP TABLE IF EXISTS `Pregunta`;
		
CREATE TABLE `Pregunta` (
  `idPregunta` INTEGER NOT NULL AUTO_INCREMENT DEFAULT NULL,
  `pregunta` VARCHAR(60) NOT NULL DEFAULT 'NULL',
  PRIMARY KEY (`idPregunta`)
);

-- ---
-- Table 'PeriodoEscolar'
-- 
-- ---

DROP TABLE IF EXISTS `PeriodoEscolar`;
		
CREATE TABLE `PeriodoEscolar` (
  `idPeriodo` INT NOT NULL AUTO_INCREMENT DEFAULT NULL,
  `fecha` DATE NOT NULL DEFAULT 'NULL',
  PRIMARY KEY (`idPeriodo`)
);

-- ---
-- Table 'Departamento'
-- 
-- ---

DROP TABLE IF EXISTS `Departamento`;
		
CREATE TABLE `Departamento` (
  `idDepartamento` INT NOT NULL AUTO_INCREMENT DEFAULT NULL,
  `nombreDepartamento` VARCHAR(20) NOT NULL DEFAULT 'NULL',
  PRIMARY KEY (`idDepartamento`)
);

-- ---
-- Table 'Materia'
-- 
-- ---

DROP TABLE IF EXISTS `Materia`;
		
CREATE TABLE `Materia` (
  `clave` INT NOT NULL DEFAULT NULL,
  `nombre` VARCHAR(50) NOT NULL DEFAULT 'NULL',
  `idDepartamento` INT NOT NULL AUTO_INCREMENT DEFAULT NULL,
  PRIMARY KEY (`clave`)
);

-- ---
-- Table 'Profesor'
-- 
-- ---

DROP TABLE IF EXISTS `Profesor`;
		
CREATE TABLE `Profesor` (
  `matrícula` INT(9) NOT NULL DEFAULT NULL,
  `nombre` VARCHAR(20) NOT NULL DEFAULT 'NULL',
  `apellidoPaterno` VARCHAR(30) NOT NULL DEFAULT 'NULL',
  `apellidoMaterno` VARCHAR(30) NOT NULL DEFAULT 'NULL',
  `rol` VARCHAR(20) NOT NULL DEFAULT 'NULL',
  `idDepartamento` INT NOT NULL AUTO_INCREMENT DEFAULT NULL,
  PRIMARY KEY (`matrícula`)
);

-- ---
-- Table 'Responde'
-- 
-- ---

DROP TABLE IF EXISTS `Responde`;
		
CREATE TABLE `Responde` (
  `matrícula` INTEGER NULL AUTO_INCREMENT DEFAULT NULL,
  `idPregunta` INTEGER NULL DEFAULT NULL,
  `CRN` INTEGER NULL DEFAULT NULL,
  `respuesta` MEDIUMTEXT(100) NULL DEFAULT NULL,
  PRIMARY KEY (`matrícula`, `idPregunta`, `CRN`)
);

-- ---
-- Table 'Comenta'
-- 
-- ---

DROP TABLE IF EXISTS `Comenta`;
		
CREATE TABLE `Comenta` (
  `idPregunta` INTEGER NULL AUTO_INCREMENT DEFAULT NULL,
  `matrícula` INTEGER NULL DEFAULT NULL,
  `CRN` INTEGER NULL DEFAULT NULL,
  `comentario` MEDIUMTEXT(100) NULL DEFAULT NULL,
  PRIMARY KEY (`idPregunta`, `matrícula`, `CRN`)
);

-- ---
-- Table 'GrupoMateria'
-- 
-- ---

DROP TABLE IF EXISTS `GrupoMateria`;
		
CREATE TABLE `GrupoMateria` (
  `CRN` INT NOT NULL DEFAULT NULL,
  `claveMateria` INT NOT NULL DEFAULT NULL,
  PRIMARY KEY (`CRN`, `claveMateria`)
);

-- ---
-- Table 'ProfesorGrupo'
-- 
-- ---

DROP TABLE IF EXISTS `ProfesorGrupo`;
		
CREATE TABLE `ProfesorGrupo` (
  `CRN` INTEGER NULL AUTO_INCREMENT DEFAULT NULL,
  `matrícula` INT(9) NOT NULL DEFAULT NULL,
  PRIMARY KEY (`CRN`, `matrícula`)
);

-- ---
-- Table 'Permisos'
-- 
-- ---

DROP TABLE IF EXISTS `Permisos`;
		
CREATE TABLE `Permisos` (
  `idPermisos` INT(2) NOT NULL AUTO_INCREMENT DEFAULT NULL,
  `rol` VARCHAR(20) NOT NULL DEFAULT 'NULL',
  PRIMARY KEY (`idPermisos`)
);

-- ---
-- Table 'Grupo'
-- 
-- ---

DROP TABLE IF EXISTS `Grupo`;
		
CREATE TABLE `Grupo` (
  `CRN` INT NOT NULL DEFAULT NULL,
  `clasifClase` VARCHAR(30) NOT NULL DEFAULT 'NULL',
  `idPeriodo` INT NOT NULL AUTO_INCREMENT DEFAULT NULL,
  `clave` INT NOT NULL DEFAULT NULL,
  PRIMARY KEY (`CRN`)
);

-- ---
-- Table 'GrupoClasifClase'
-- 
-- ---

DROP TABLE IF EXISTS `GrupoClasifClase`;
		
CREATE TABLE `GrupoClasifClase` (
  `CRN` INTEGER NOT NULL DEFAULT NULL,
  `clasifClase` VARCHAR(30) NOT NULL DEFAULT 'NULL',
  PRIMARY KEY (`CRN`, `clasifClase`)
);

-- ---
-- Foreign Keys 
-- ---

ALTER TABLE `Materia` ADD FOREIGN KEY (idDepartamento) REFERENCES `Departamento` (`idDepartamento`);
ALTER TABLE `Profesor` ADD FOREIGN KEY (idDepartamento) REFERENCES `Departamento` (`idDepartamento`);
ALTER TABLE `Responde` ADD FOREIGN KEY (matrícula) REFERENCES `Alumno` (`matrícula`);
ALTER TABLE `Responde` ADD FOREIGN KEY (idPregunta) REFERENCES `Pregunta` (`idPregunta`);
ALTER TABLE `Responde` ADD FOREIGN KEY (CRN) REFERENCES `Grupo` (`CRN`);
ALTER TABLE `Comenta` ADD FOREIGN KEY (idPregunta) REFERENCES `Pregunta` (`idPregunta`);
ALTER TABLE `Comenta` ADD FOREIGN KEY (matrícula) REFERENCES `Alumno` (`matrícula`);
ALTER TABLE `Comenta` ADD FOREIGN KEY (CRN) REFERENCES `Grupo` (`CRN`);
ALTER TABLE `GrupoMateria` ADD FOREIGN KEY (CRN) REFERENCES `Grupo` (`CRN`);
ALTER TABLE `GrupoMateria` ADD FOREIGN KEY (claveMateria) REFERENCES `Materia` (`clave`);
ALTER TABLE `ProfesorGrupo` ADD FOREIGN KEY (CRN) REFERENCES `Grupo` (`CRN`);
ALTER TABLE `ProfesorGrupo` ADD FOREIGN KEY (matrícula) REFERENCES `Profesor` (`matrícula`);
ALTER TABLE `Grupo` ADD FOREIGN KEY (idPeriodo) REFERENCES `PeriodoEscolar` (`idPeriodo`);
ALTER TABLE `Grupo` ADD FOREIGN KEY (clave) REFERENCES `Materia` (`clave`);
ALTER TABLE `GrupoClasifClase` ADD FOREIGN KEY (CRN) REFERENCES `Grupo` (`CRN`);

-- ---
-- Table Properties
-- ---

-- ALTER TABLE `Alumno` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `Pregunta` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `PeriodoEscolar` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `Departamento` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `Materia` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `Profesor` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `Responde` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `Comenta` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `GrupoMateria` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `ProfesorGrupo` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `Permisos` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `Grupo` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `GrupoClasifClase` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ---
-- Test Data
-- ---

-- INSERT INTO `Alumno` (`matrícula`,`nombre`,`apellidoPaterno`,`apellidoMaterno`,`matrícula_Responde`) VALUES
-- ('','','','','');
-- INSERT INTO `Pregunta` (`idPregunta`,`pregunta`) VALUES
-- ('','');
-- INSERT INTO `PeriodoEscolar` (`idPeriodo`,`fecha`) VALUES
-- ('','');
-- INSERT INTO `Departamento` (`idDepartamento`,`nombreDepartamento`) VALUES
-- ('','');
-- INSERT INTO `Materia` (`clave`,`nombre`,`idDepartamento`) VALUES
-- ('','','');
-- INSERT INTO `Profesor` (`matrícula`,`nombre`,`apellidoPaterno`,`apellidoMaterno`,`rol`,`idDepartamento`) VALUES
-- ('','','','','','');
-- INSERT INTO `Responde` (`matrícula`,`idPregunta`,`CRN`,`respuesta`) VALUES
-- ('','','','');
-- INSERT INTO `Comenta` (`idPregunta`,`matrícula`,`CRN`,`comentario`) VALUES
-- ('','','','');
-- INSERT INTO `GrupoMateria` (`CRN`,`claveMateria`) VALUES
-- ('','');
-- INSERT INTO `ProfesorGrupo` (`CRN`,`matrícula`) VALUES
-- ('','');
-- INSERT INTO `Permisos` (`idPermisos`,`rol`) VALUES
-- ('','');
-- INSERT INTO `Grupo` (`CRN`,`clasifClase`,`idPeriodo`,`clave`) VALUES
-- ('','','','');
-- INSERT INTO `GrupoClasifClase` (`CRN`,`clasifClase`) VALUES
-- ('','');
