<!DOCTYPE html>
<!--
To change this license header, choose License Headers in Project Properties.
To change this template file, choose Tools | Templates
and open the template in the editor.
-->
<html>
    <head>
        <meta charset="UTF-8">
        <title>Gestión</title>
    </head>
    <body>
        <?php
        require_once '../Modelo/Persona.php';
        require_once '../Modelo/Region.php';
        session_start();

        if (isset($_SESSION['usuarioLogin'])) {
            $usuarioLogin = $_SESSION['usuarioLogin'];
            $rolesUsuario = $usuarioLogin->getRoles();
        }

        if (isset($_SESSION['semanasDisponibles'])) {
            $semanasDisponibles = $_SESSION['semanasDisponibles'];
        }

        if (isset($_SESSION['semana'])) {
            $semana = $_SESSION['semana'];
        }

        if (isset($_SESSION['regionesPorSemana'])) {
            $regionesPorSemana = $_SESSION['regionesPorSemana'];
        }
        ?>

        <h1>Bienvenido <?php echo $usuarioLogin->getNombre() . ' ' . $usuarioLogin->getApellidos() ?></h1>

        <?php
        if (isset($rolesUsuario)) {
            if ($rolesUsuario[0] == "Administrador / Gestor") {
                ?>
                <form action="../Controladores/controlador.php" name="form_cambiarRol" method="POST">
                    <input type="submit" name="bt_cambioRol" value="Ir a Admin">
                </form>
                <?php
            }
        }
        ?>

        <form action="../Controladores/controlador.php" name="form_cerrarSesion" method="POST">
            <input type="submit" name="cerrarSesion" value="Cerrar Sesion">
        </form>

        <?php
        if (isset($semanasDisponibles)) {
            if (sizeof($semanasDisponibles) > 0) {
                ?>
                <form action="../Controladores/controlador.php" name="form_semanas" method="POST">
                    Semana a buscar:
                    <select name="semanaFiltrar"  onclick="this.form.submit();">
                        <option disabled selected>Seleccione una semana</option>
                        <?php
                        foreach ($semanasDisponibles as $r => $v) {
                            ?>
                            <option name="semana"><?php echo $r[$v] ?></option>
                            <?php
                        }
                        ?>
                    </select>
                </form>
        <?php
    }
}

if (isset($semana)) {
    ?>
            <h1><?php echo $semana ?></h1>
            <?php
        }

        if (isset($regionesPorSemana)) {
            if (sizeof($regionesPorSemana) > 0) {
                ?>
                <table>
                    <tr>
                        <th>Región</th>
                        <th>Número de Infectados</th>
                        <th>Número de Fallecidos</th>
                        <th>Número de Altas</th>
                        <th colspan="2">Opciones</th>
                    </tr>
        <?php
        for ($i = 0; $i < sizeof($regionesPorSemana); $i++) {
            $r = $regionesPorSemana[$i];
            ?>
                        <form action="../Controladores/controlador.php" name="form_regionesPorSemanas" method="POST">
                            <tr>
                                <td><input type="text" name="region" value="<?php echo $r->getRegion() ?>" readonly></td>
                                <td><input type="number" name="numInfectados" value="<?php echo $r->getNumInfectados() ?>"></td>
                                <td><input type="number" name="numFallecidos" value="<?php echo $r->getNumFallecidos() ?>"></td>
                                <td><input type="number" name="numAltas" value="<?php echo $r->getNumAltas() ?>"></td>
                                <td>
                                    <input type="submit" name="bt_Gestor" value="Editar">
                                </td>
                                <td>
                                    <input type="submit" name="bt_Gestor" value="Borrar">
                                </td>
                            </tr>
                        </form>
            <?php
        }
        ?>
                </table>
                    <?php
                }
            }
            ?>
    </body>
</html>
