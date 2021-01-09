<!DOCTYPE html>
<!--
To change this license header, choose License Headers in Project Properties.
To change this template file, choose Tools | Templates
and open the template in the editor.
-->
<html>
    <head>
        <meta charset="UTF-8">
        <title>Administración</title>
    </head>
    <body>
        <?php
        require_once '../Modelo/Persona.php';
        session_start();


        if (isset($_SESSION['usuarioLogin'])) {
            $usuarioLogin = $_SESSION['usuarioLogin'];
            $rolesUsuario = $usuarioLogin->getRoles();
        }

        if (isset($_SESSION['listaPersonas'])) {
            $listaPersonas = $_SESSION['listaPersonas'];
        }
        ?>
        <h1>Bienvenido <?php echo $usuarioLogin->getNombre() . ' ' . $usuarioLogin->getApellidos() ?></h1>

        <?php
        if ($rolesUsuario[0] == "Administrador / Gestor") {
            ?>
            <form action="../Controladores/controlador.php" name="form_cambiarRol" method="POST">
                <input type="submit" name="bt_cambioRol" value="Ir a Gestor">
            </form>
            <?php
        }
        ?>

        <form action="../Controladores/controlador.php" name="form_cerrarSesion" method="POST">
            <input type="submit" name="cerrarSesion" value="Cerrar Sesion">
        </form>

        <form action="../Controladores/controlador.php" name="form_verRegiones" method="POST">
            <input type="submit" name="verRegiones" value="Ver regiones">
        </form>

        <form action="../Controladores/controlador.php" name="form_verSemanas" method="POST">
            <input type="submit" name="verSemanas" value="Ver semanas">
        </form>

        <h4>Crear un nuevo usuario</h4>
        <table>
            <tr>
                <th>Nombre</th>
                <th>Apellidos</th>
                <th>DNI</th>
                <th>Correo electrónico</th>
                <th>Contraseña</th>
                <th>Activado / Desactivado</th>
                <th>Rol asignado</th>
            </tr>
            <form action="../Controladores/controlador.php" name="form_CRUD_addUser" method="POST">
                <tr>
                    <td>
                        <input type="text" name="new_nombre" placeholder="Nombre" required>
                    </td>
                    <td>
                        <input type="text" name="new_apellidos" placeholder="Apellidos" required>
                    </td>
                    <td>
                        <input type="text" name="new_dni" placeholder="DNI" required>
                    </td>
                    <td>
                        <input type="email" name="new_correo" placeholder="Correo electrónico" required>
                    </td>
                    <td>
                        <input type="text" name="new_contra" placeholder="Contraseña" required>
                    </td>
                    <td>
                        <select name="new_onOff">
                            <option name="activado" value="Activado" selected>Activado</option>
                            <option name="desactivado" value="Desactivado">Desactivado</option>
                        </select>
                    </td>
                    <td>
                        <select name="new_rol">
                            <option name="gestor" >Gestor</option>
                            <option name="administradorGestor">Administrador / Gestor</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td colspan="7">
                        <input type="submit" name="bt_admin" value="Crear usuario">
                    </td>
                </tr>
            </form>
        </table>

        <h4>Usuarios registrados</h4>

        <table>
            <tr>
                <th>Nombre</th>
                <th>Apellidos</th>
                <th>DNI</th>
                <th>Correo electrónico</th>
                <th>Activado / Desactivado</th>
                <th>Rol asignado</th>
            </tr>
            <?php
            if (isset($listaPersonas)) {
                for ($i = 0; $i < sizeof($listaPersonas); $i++) {
                    $aux = $listaPersonas[$i];
                    ?>
                    <form action="../Controladores/controlador.php" name="form_usuarioCRUD" method="POST">
                        <tr>
                            <td><input type="text" name="nombre" value="<?php echo $aux->getNombre() ?>" readonly></td>
                            <td><input type="text" name="apellidos" value="<?php echo $aux->getApellidos() ?>" readonly></td>
                            <td><input type="text" name="dni" value="<?php echo $aux->getDni() ?>" readonly></td>
                            <td><input type="text" name="correo" value="<?php echo $aux->getCorreo() ?>"></td>
                            <?php
                            if ($aux->getActivado() == 1) {
                                ?>
                                <td>
                                    <select name="onOff">
                                        <option name="activado" value="Activado" selected>Activado</option>
                                        <option name="desactivado" value="Desactivado">Desactivado</option>
                                    </select>
                                </td>
                                <?php
                            } else {
                                ?>
                                <td>
                                    <select name="onOff">
                                        <option name="activado" value="Activado">Activado</option>
                                        <option name="desactivado" value="Desactivado" selected>Desactivado</option>
                                    </select>
                                </td>
                                <?php
                            }
                            ?>

                            <?php
                            if (sizeof($rolesUsuario) == 1) {
                                $rol = $rolesUsuario[0];
                                if ($rol == "Gestor") {
                                    ?>
                                    <td>
                                        <select name="rol">
                                            <option name="gestor" selected>Gestor</option>
                                            <option name="administradorGestor">Administrador / Gestor</option>
                                        </select>
                                    </td>
                                    <?php
                                }
                                if ($rol == "Administrador / Gestor") {
                                    ?>
                                    <td>
                                        <select name="rol">
                                            <option name="gestor">Gestor</option>
                                            <option name="administradorGestor" selected>Administrador / Gestor</option>
                                        </select>
                                    </td>
                                    <?php
                                }
                            }
                            ?>

                            <td>
                                <input type="submit" name="bt_admin" value="Editar">
                            </td>

                            <td>
                                <input type="submit" name="bt_admin" value="Borrar">
                            </td>

                        </tr>
                    </form>

                    <?php
                }
            } else {
                ?>
                <td colspan="9">No hay usuarios registrados</td>
                <?php
            }
            ?>
        </table>

    </body>
</html>
