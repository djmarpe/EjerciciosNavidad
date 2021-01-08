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

}
