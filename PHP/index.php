<!DOCTYPE html>
<!--
To change this license header, choose License Headers in Project Properties.
To change this template file, choose Tools | Templates
and open the template in the editor.
-->
<html>
    <head>
        <meta charset="UTF-8">
        <title>Página principal</title>
    </head>
    <body>
        <?php
        session_start();
//        require_once 'Auxiliar/ConexionEstatica.php';
//        //---------- Semanas disponibles---------------------
//        $semanasDisponibles = null;
//        $semana = null;
//        $regionesSemanas = null;
//
//        if (isset($_SESSION['semanasDisponibles'])) {
//            $semanasDisponibles = $_SESSION['semanasDisponibles'];
//        } else {
//            $semanasDisponibles = ConexionEstatica . getSemanas();
//            session . setAttribute("semanasDisponibles", semanasDisponibles);
//        }
//
//        //------- Regiones por semana ---------------------
//        if (session . getAttribute("regionesPorSemanas") != null) {
//            if (session . getAttribute("semana") != null) {
//                $semana = $_SESSION['semana'];
//                regionesSemanas = (LinkedList) session . getAttribute("regionesPorSemanas");
//            }
//        } else {
//            semana = "Semana 1";
//            LinkedList regionesAux = ConexionEstatica . getRegiones(semana);
//            LinkedList regiones = ConexionEstatica . getNombreRegiones(regionesAux);
//            session . setAttribute("regionesPorSemanas", regiones);
//            session . setAttribute("semana", semana);
//            regionesSemanas = (LinkedList) session . getAttribute("regionesPorSemanas");
//        }

        if (isset($_SESSION['mensajeLogin'])) {
            $mensaje = $_SESSION['mensajeLogin'];
            echo $mensaje;
        }
        ?>
        <form action="Controladores/controlador.php" name="form_login" method="POST">
            <table>
                <tr>
                    <td>Usuario:</td>
                    <td>
                        <input type="email" name="correo" placeholder="Correo electronico" required>
                    </td>
                </tr>
                <tr>
                    <td>Contraseña:</td>
                    <td>
                        <input type="password" name="contra" placeholder="Contraseña" required>
                    </td>
                </tr>
                <tr>
                    <td colspan="2"><input type="submit" name="iniciarSesion" value="Iniciar Sesion"></td>
                </tr>
            </table>
        </form>
    </body>
</html>
