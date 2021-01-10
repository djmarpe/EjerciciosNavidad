<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of ConexionEstatica
 *
 * @author alejandro
 */
class ConexionEstatica {

    public static $conexion;

    public static function abrirConex() {
        self::$conexion = new mysqli('localhost', 'alejandro', 'Chubaca2020', 'COVID19_PHP');

        if (self::$conexion->connect_errno) {
            print "Fallo al conectar a MySQL: " . mysqli_connect_error();
        }
    }

    public static function cerrarConex() {
        self::$conexion = NULL;
    }

    public static function existeUsuario($correo, $contra) {
        $existe = false;
        self::abrirConex();

        $sentencia = "SELECT * FROM Usuario WHERE correo = '" . $correo . "' AND contra = '" . $contra . "'";

        if ($resultado = mysqli_query(self::$conexion, $sentencia)) {
            if ($fila = mysqli_fetch_array($resultado)) {
                $existe = true;
            }
        }
        self::cerrarConex();
        return $existe;
    }

    public static function getPersona($correo, $contra) {
        $aux = new Persona();
        self::abrirConex();

        $sentencia = "Select Usuario.Nombre, Usuario.Apellidos, Usuario.DNI, Usuario.Correo, Usuario.Contra, Usuario.Activado, Rol.Rol from Usuario, Rol, AsignacionRol where Usuario.Correo = '" . $correo . "' and Usuario.Contra = '" . $contra . "' and AsignacionRol.DNI = Usuario.DNI and AsignacionRol.idRol=Rol.idRol;";

        if ($resultado = mysqli_query(self::$conexion, $sentencia)) {
            while ($fila = mysqli_fetch_array($resultado)) {
                $aux->setNombre($fila[0]);
                $aux->setApellidos($fila[1]);
                $aux->setDni($fila[2]);
                $aux->setCorreo($fila[3]);
                $aux->setContra($fila[4]);
                $aux->setActivado($fila[5]);
                $aux->addRol($fila[6]);
            }
        }
        self::cerrarConex();
        return $aux;
    }

    public static function getPersonas() {
        $listaAux = [];
        self::abrirConex();

        $sentencia = "Select Usuario.Nombre, Usuario.Apellidos, Usuario.DNI, Usuario.Correo, Usuario.Activado, Rol.Rol from Usuario, Rol, AsignacionRol where AsignacionRol.DNI = Usuario.DNI and AsignacionRol.idRol=Rol.idRol;";

        if ($resultado = mysqli_query(self::$conexion, $sentencia)) {
            while ($fila = mysqli_fetch_array($resultado)) {
                $p = new Persona();
                $p->setNombre($fila['Nombre']);
                $p->setApellidos($fila['Apellidos']);
                $p->setDni($fila['DNI']);
                $p->setCorreo($fila['Correo']);
                $p->setActivado($fila['Activado']);
                $p->addRol($fila['Rol']);
                $listaAux[] = $p;
            }
        }

        self::cerrarConex();
        return $listaAux;
    }

    public static function addUsuario($aux) {
        $add = false;
        $idRol;
        self::abrirConex();

        $sentencia1 = "INSERT INTO Usuario VALUES('" . $aux->getNombre() . "','" . $aux->getApellidos() . "','" . $aux->getDni() . "','" . $aux->getCorreo() . "','" . $aux->getContra() . "'," . $aux->getActivado() . ")";

        if (mysqli_query(self::$conexion, $sentencia1)) {
            $rolesUsuario = $aux->getRoles();
            $sentencia2 = "SELECT idRol FROM Rol WHERE Rol = '" . $rolesUsuario[0] . "'";
            if ($resultado = mysqli_query(self::$conexion, $sentencia2)) {
                if ($fila = mysqli_fetch_array($resultado)) {
                    $idRol = $fila['idRol'];
                    $sentencia3 = "INSERT INTO AsignacionRol VALUES(" . $idRol . ",'" . $aux->getDni() . "')";
                    if (mysqli_query(self::$conexion, $sentencia3)) {
                        $add = true;
                    }
                }
            }
        }
        self::cerrarConex();
        return add;
    }

    public static function borrarUsuario($dni) {
        $deleteado = false;
        self::abrirConex();

        $sentencia1 = "DELETE FROM Usuario WHERE DNI = '" . $dni . "'";
        if (mysqli_query(self::$conexion, $sentencia1)) {
            $sentencia2 = "DELETE FROM AsignacionRol WHERE DNI = '" . dni . "'";
            if (mysqli_query(self::$conexion, $sentencia2)) {
                $deleteado = true;
            }
        }

        self::cerrarConex();
        return $deleteado;
    }

    public static function editarUsuario($aux) {
        $editado = false;
        self::abrirConex();

        $sentencia1 = "UPDATE Usuario SET Correo = '" . $aux->getCorreo() . "', Activado = " . $aux->getActivado() . " WHERE DNI = '" . $aux->getDni() . "'";

        if (mysqli_query(self::$conexion, $sentencia1)) {
            $rolesUsuario = $aux->getRoles();

            if ($rolesUsuario[0] == "Gestor") {
                $sentencia2 = "DELETE FROM AsignacionRol WHERE dni = '" . $aux->getDni() . "'";
                if (mysqli_query(self::$conexion, $sentencia2)) {
                    $sentencia3 = "INSERT INTO AsignacionRol values(1,'" . $aux->getDni() . "')";
                    if (mysqli_query(self::$conexion, $sentencia3)) {
                        $editado = true;
                    }
                }
            }

            if ($rolesUsuario[0] == "Administrador / Gestor") {
                $sentencia2 = "DELETE FROM AsignacionRol WHERE dni = '" . $aux->getDni() . "'";
                if (mysqli_query(self::$conexion, $sentencia2)) {
                    $sentencia3 = "INSERT INTO AsignacionRol values(2,'" . $aux->getDni() . "')";
                    if (mysqli_query(self::$conexion, $sentencia3)) {
                        $editado = true;
                    }
                }
            }
        }
        self::cerrarConex();
        return $editado;
    }

    public static function getSemanas() {
        $aux = [];
        self::abrirConex();

        $sentencia = "SELECT * FROM Semana";

        if ($resultado = mysqli_query(self::$conexion, $sentencia)) {
            while ($fila = mysqli_fetch_array($resultado)) {
                $aux[] = $fila["Semana"];
            }
        }

        self::cerrarConex();
        return $aux;
    }

    public static function getRegiones($semana) {
        $aux = [];
        $idSemana = 0;
        $idRegion = 0;
        $nombreRegion = "";
        self::abrirConex();

        $r = null;
        $sentencia1 = "SELECT idSemana FROM Semana WHERE Semana = '" . $semana . "'";
        if ($resultado1 = mysqli_query(self::$conexion, $sentencia1)) {
            if ($fila1 = mysqli_fetch_array($resultado1)) {
                $idSemana = $fila1["idSemana"];
                $sentencia2 = "SELECT * FROM InfeccionSemanal WHERE idSemana = " . $idSemana;
                if ($resultado2 = mysqli_query(self::$conexion, $sentencia2)) {
                    while ($fila2 = mysqli_fetch_array($resultado2)) {
                        $r = new Region();
                        $r->setSemana($semana);
                        $r->setNumInfectados($fila2['NumInfectados']);
                        $r->setNumFallecidos($fila2['NumFallecidos']);
                        $r->setNumAltas($fila2['NumAltas']);
                        $r->setRegion($fila2['idRegion']);
                        $aux[] = $r;
                    }
                }
            }
        }
        self::cerrarConex();
        return $aux;
    }

    public static function getNombreRegiones($regiones) {
        self::abrirConex();

        for ($i = 0; $i < sizeof($regiones); $i++) {
            $r = $regiones[$i];
            $sentencia = "SELECT Nombre FROM Region WHERE idRegion = " . $r->getRegion();
            if ($resultado = mysqli_query(self::$conexion, $sentencia)) {
                if ($fila = mysqli_fetch_array($resultado)) {
                    $r->setRegion($fila['Nombre']);
                }
            }
        }

        self::cerrarConex();
        return $regiones;
    }

    public static function getIdSemana($semana) {
        self::abrirConex();

        $sentencia = "SELECT idSemana FROM Semana WHERE Semana = '" . $semana . "'";

        if ($resultado = mysqli_query(self::$conexion, $sentencia)) {
            if ($fila = mysqli_fetch_array($resultado)) {
                $idSemana = $fila['idSemana'];
            }
        }
        self::cerrarConex();
        return $idSemana;
    }

    public static function getIdRegion($region) {
        self::abrirConex();

        $sentencia = "SELECT idRegion FROM Region WHERE Nombre = '" . $region . "'";

        if ($resultado = mysqli_query(self::$conexion, $sentencia)) {
            if ($fila = mysqli_fetch_array($resultado)) {
                $idRegion = $fila['idRegion'];
            }
        }

        self::cerrarConex();
        return $idRegion;
    }

}
