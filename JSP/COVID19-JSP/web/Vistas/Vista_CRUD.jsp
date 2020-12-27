<%-- 
    Document   : Vista_CRUD
    Created on : 26-dic-2020, 14:17:44
    Author     : alejandro
--%>

<%@page import="java.util.LinkedList"%>
<%@page import="Modelo.Persona"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Panel de Administración</title>
    </head>
    <body>
        <%
            Persona usuarioLogin = (Persona) session.getAttribute("usuarioLogin");

            LinkedList listaPersonas = (LinkedList) session.getAttribute("listaPersonas");
        %>

        <h1>Bienvenido: <%= usuarioLogin.getNombre() + " " + usuarioLogin.getApellidos()%></h1>

        <form action="../Controladores/controlador.jsp" name="form_cerrarSesion" method="POST">
            <input type="submit" name="cerrarSesion" value="Cerrar Sesion">
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
            <form action="../Controladores/controlador.jsp" name="form_CRUD_addUser" method="POST">
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
            <%
                for (int i = 0; i < listaPersonas.size(); i++) {
                    Persona aux = (Persona) listaPersonas.get(i);
            %>
            <form action="../Controladores/controlador.jsp" name="form_usuarioCRUD" method="POST">
                <tr>
                    <td><input type="text" name="nombre" value="<%= aux.getNombre()%>" readonly></td>
                    <td><input type="text" name="apellidos" value="<%= aux.getApellidos()%>" readonly></td>
                    <td><input type="text" name="dni" value="<%= aux.getDni()%>" readonly></td>
                    <td><input type="text" name="correo" value="<%= aux.getCorreo()%>"></td>
                        <%

                            if (aux.getActivado() == 1) {
                        %>
                    <td>
                        <select name="onOff">
                            <option name="activado" value="Activado" selected>Activado</option>
                            <option name="desactivado" value="Desactivado">Desactivado</option>
                        </select>
                    </td>
                    <%
                    } else {
                    %>
                    <td>
                        <select name="onOff">
                            <option name="activado" value="Activado">Activado</option>
                            <option name="desactivado" value="Desactivado" selected>Desactivado</option>
                        </select>
                    </td>
                    <%
                        }

                    %>

                    <%                        LinkedList roles = aux.getRoles();
                        if (roles.size() == 1) {
                            String rol = (String) roles.get(0);
                            if (rol.equals("Gestor")) {
                    %>
                    <td>
                        <select name="rol">
                            <option name="gestor" selected>Gestor</option>
                            <option name="administradorGestor">Administrador / Gestor</option>
                        </select>
                    </td>
                    <%
                        }
                        if (rol.equals("Administrador / Gestor")) {
                    %>
                    <td>
                        <select name="rol">
                            <option name="gestor">Gestor</option>
                            <option name="administradorGestor" selected>Administrador / Gestor</option>
                        </select>
                    </td>
                    <%
                            }
                        }
                    %>

                    <td>
                        <input type="submit" name="bt_admin" value="Editar">
                    </td>

                    <td>
                        <input type="submit" name="bt_admin" value="Borrar">
                    </td>

                </tr>
            </form>
            <%                        }
            %>
        </table>

    </body>
</html>
