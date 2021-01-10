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
                $semanasDisponibles = ConexionEstatica::getSemanas();
                $_SESSION['semanasDisponibles'] = $semanasDisponibles;
                header('Location: ../Vistas/Vista_Gestor.php');
            }
            if ($roles[0] == "Administrador / Gestor") {
                $listaPersonas = ConexionEstatica::getPersonas();
                $_SESSION['listaPersonas'] = $listaPersonas;
                header('Location: ../Vistas/Vista_CRUD.php');
            }
        }
    } else {
        $_SESSION['mensajeLogin'] = "Credenciales incorrectas";
        header('Location: ../index.php');
    }
}

if ($_REQUEST['bt_admin'] != null) {
    $botonPulsado = $_REQUEST['bt_admin'];

    if ($botonPulsado == "Editar") {
        $aux = new Persona();
        $aux->setNombre($_REQUEST['nombre']);
        $aux->setApellidos($_REQUEST['apellidos']);
        $aux->setDni($_REQUEST['dni']);
        $aux->setCorreo($_REQUEST['correo']);
        $onOff = $_REQUEST['onOff'];
        if ($onOff == "Activado") {
            $activado = 1;
            $aux->setActivado($activado);
        } else {
            $activado = 0;
            $aux->setActivado($activado);
        }
        $aux->addRol($_REQUEST['rol']);
        if (ConexionEstatica::editarUsuario($aux)) {
            $listaPersonas = ConexionEstatica::getPersonas();
            $_SESSION['listaPersonas'] = $listaPersonas;
            header('Location: ../Vistas/Vista_CRUD.php');
        }
    }

    if ($botonPulsado == "Borrar") {
        $dni = $_REQUEST['dni'];
        if (ConexionEstatica::borrarUsuario($dni)) {
            $listaPersonas = ConexionEstatica::getPersonas();
            $_SESSION['listaPersonas'] = $listaPersonas;
            header('Location: ../Vistas/Vista_CRUD.php');
        }
    }

    if ($botonPulsado == "Crear usuario") {
        $aux = new Persona();
        $aux->setNombre($_REQUEST["new_nombre"]);
        $aux->setApellidos($_REQUEST["new_apellidos"]);
        $aux->setDni($_REQUEST["new_dni"]);
        $aux->setCorreo($_REQUEST["new_correo"]);
        $aux->setContra($_REQUEST["new_contra"]);
        if ($_REQUEST["new_onOff"] == "Activado") {
            $aux->setActivado(1);
        } else if ($_REQUEST['new_onOff'] == "Desactivado") {
            $aux->setActivado(0);
        }
        if ($_REQUEST["new_rol"] == "Gestor") {
            $aux->addRol("Gestor");
        } else if ($_REQUEST["new_rol"] == "Administrador / Gestor") {
            $aux->addRol("Administrador / Gestor");
        }

        if (ConexionEstatica::addUsuario($aux)) {
            $listaPersonas = ConexionEstatica::getPersonas();
            $_SESSION['listaPersonas'] = $listaPersonas;
            header('Location: ../Vistas/Vista_CRUD.php');
        }
    }
}


if ($_REQUEST["semanaFiltrar"] != null) {
    $semana = $_REQUEST["semanaFiltrar"];
    $_SESSION['semana'] = $semana;
    $regionesAux = ConexionEstatica::getRegiones($semana);
    $regiones = ConexionEstatica::getNombreRegiones($regionesAux);
    $idSemana = ConexionEstatica::getIdSemana($_SESSION['semana']);
    $regionesDisponibles = ConexionEstatica::getRegionesDisponibles($idSemana);
    $_SESSION['regionesDisponibles'] = $regionesDisponibles;
    $_SESSION['regionesPorSemanas'] = $regiones;
    header('Location: ../Vistas/Vista_Gestor.php');
}


if ($_REQUEST['cerrarSesion'] != null) {
    $_SESSION["usuarioLogin"] = null;
    $_SESSION["listaPersonas"] = null;
    $_SESSION["mensajeLogin"] = "Sesión cerrada correctamente";
    header('Location: ../index.php');
}

