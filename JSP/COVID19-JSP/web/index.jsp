<%-- 
    Document   : Vista_Login
    Created on : 26-dic-2020, 14:57:52
    Author     : alejandro
--%>

<%@page import="Modelo.Region"%>
<%@page import="Modelo.ConexionEstatica"%>
<%@page import="java.util.LinkedList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Index</title>
    </head>
    <body>
        <%
            //---------- Semanas disponibles---------------------
            LinkedList semanasDisponibles = null;
            String semana = null;
            LinkedList regionesSemanas = null;
            if (session.getAttribute("semanasDisponibles") == null) {
                semanasDisponibles = ConexionEstatica.getSemanas();
                session.setAttribute("semanasDisponibles", semanasDisponibles);
            } else {
                semanasDisponibles = (LinkedList) session.getAttribute("semanasDisponibles");
            }

            //------- Regiones por semana ---------------------
            if (session.getAttribute("regionesPorSemanas") != null) {
                if (session.getAttribute("semana") != null) {
                    semana = (String) session.getAttribute("semana");
                    regionesSemanas = (LinkedList) session.getAttribute("regionesPorSemanas");
                }
            } else {
                semana = "Semana 1";
                LinkedList regionesAux = ConexionEstatica.getRegiones(semana);
                LinkedList regiones = ConexionEstatica.getNombreRegiones(regionesAux);
                session.setAttribute("regionesPorSemanas", regiones);
                session.setAttribute("semana", semana);
                regionesSemanas = (LinkedList) session.getAttribute("regionesPorSemanas");
            }

            String mensaje = "";
            if (session.getAttribute("mensajeLogin") != null) {
                mensaje = (String) session.getAttribute("mensajeLogin");
            }

            if (!mensaje.isEmpty()) {
        %>
        <h5><%= mensaje%></h5>
        <%
            }
        %>
        <form action="Controladores/controlador.jsp" name="form_login" method="POST">
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
        <%
            if (semanasDisponibles != null) {

                if (semanasDisponibles.size() > 0) {
        %>
        <form action="Controladores/controlador.jsp" name="form_semanas" method="POST">
            Semana a buscar:
            <select name="semanaFiltrarIndex"  onclick="this.form.submit();">
                <option disabled selected>Seleccione una semana</option>
                <%
                    for (int i = 0; i < semanasDisponibles.size(); i++) {
                %>
                <option name="semana"><%= semanasDisponibles.get(i)%></option>
                <%
                    }
                %>
            </select>
        </form>
        <%
                }
            }
        %>

        <h3><%= semana%></h3>
        <%
            if (regionesSemanas.size() > 0) {
        %>
        <table>
            <tr>
                <th>Región</th>
                <th>Número de Infectados</th>
                <th>Número de Fallecidos</th>
                <th>Número de Altas</th>
            </tr>
            <% for (int i = 0; i < regionesSemanas.size(); i++) {
                    Region r = (Region) regionesSemanas.get(i);
            %>
            <form action="../Controladores/controlador.jsp" name="form_regionesPorSemanas" method="POST">
                <tr>
                    <td><input type="text" name="region" value="<%= r.getRegion()%>" readonly></td>
                    <td><input type="number" name="numInfectados" value="<%= r.getNumInfectados()%>" readonly></td>
                    <td><input type="number" name="numFallecidos" value="<%= r.getNumFallecidos()%>" readonly></td>
                    <td><input type="number" name="numAltas" value="<%= r.getNumAltas()%>" readonly></td>
                </tr>
            </form>
            <%
                }
            %>

        </table>

        <%
        } else {
        %>
        <h3>No hay datos</h3>
        <%
            }
        %>
    </body>
</html>
