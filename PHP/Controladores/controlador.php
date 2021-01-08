<?php

session_start();
require_once '../Auxiliar/ConexionEstatica.php';
require_once '../Modelo/Persona.php';

if ($_REQUEST['iniciarSesion'] != null) {
    $correo = $_REQUEST['correo'];
    $contra = $_REQUEST['contra'];

    if (ConexionEstatica::existeUsuario($correo, $contra)) {
        $aux = ConexionEstatica::getPersona($correo, $contra);
        if ($aux->getActivado() == 0) {
            $_SESSION['mensajeLogin'] = "Usuario deshabilitado. Contacte con el administrador.";
            header('Location: ../index.php');
        } else {
            $_SESSION['usuarioLogin'] = $aux;
            $roles = $aux->getRoles();
            if ($roles[0] == "Gestor") {
                //$semanasDisponibles = ConexionEstatica::getSemanas();
                //$_SESSION['semanasDisponibles'] = $semanasDisponibles;
                header('Location: ../Vistas/Vista_Gestor.php');
            }
            if ($roles[0] == "Administrador / Gestor") {
                //$listaPersonas = ConexionEstatica::getPersonas();
                //$_SESSION['listaPersonas'] = $listaPersonas;
                header('Location: ../Vistas/Vista_CRUD.php');
            }
        }
    } else {
        $_SESSION['mensajeLogin'] = "Credenciales incorrectas";
        header('Location: ../index.php');
    }
}

