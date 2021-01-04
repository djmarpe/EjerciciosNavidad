<%-- 
    Document   : controlador
    Created on : 26-dic-2020, 15:05:33
    Author     : alejandro
--%>

<%@page import="java.util.LinkedList"%>
<%@page import="Modelo.Persona"%>
<%@page import="Modelo.ConexionEstatica"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if (request.getParameter("iniciarSesion") != null) {
        String correo = request.getParameter("correo");
        String contra = request.getParameter("contra");
        
        if (ConexionEstatica.existeUsuario(correo, contra)) {
            Persona aux = ConexionEstatica.getPersona(correo, contra);
            if (aux.getActivado() == 0) {
                session.setAttribute("mensajeLogin", "Usuario deshabilitado");
                response.sendRedirect("../Vistas/Vista_Login.jsp");
            } else {
                session.setAttribute("usuarioLogin", aux);
                LinkedList roles = aux.getRoles();
                if (roles.get(0).equals("Gestor")) {
                    response.sendRedirect("../Vistas/Vista_Gestor.jsp");
                }
                if (roles.get(0).equals("Administrador / Gestor")) {
                    LinkedList listaPersonas = ConexionEstatica.getPersonas();
                    session.setAttribute("listaPersonas", listaPersonas);
                    response.sendRedirect("../Vistas/Vista_CRUD.jsp");
                }
            }
            
        } else {
            session.setAttribute("mensajeLogin", "Credenciales incorrectas");
            response.sendRedirect("../Vistas/Vista_Login.jsp");
        }
        
    }

    //**************************************************************************
    //****************************** Ventana CRUD ******************************
    //**************************************************************************
    if (request.getParameter("bt_admin") != null) {
        String botonPulsado = request.getParameter("bt_admin");
        //----------------------------------------------------------------------
        //-------------------- Si pulsamos editar ------------------------------
        //----------------------------------------------------------------------
        if (botonPulsado.equals("Editar")) {
            Persona aux = new Persona();
            aux.setNombre(request.getParameter("nombre"));
            aux.setApellidos(request.getParameter("apellidos"));
            aux.setDni(request.getParameter("dni"));
            aux.setCorreo(request.getParameter("correo"));
            String onOff = request.getParameter("onOff");
            if (onOff.equals("Activado")) {
                int activado = 1;
                aux.setActivado(activado);
            } else {
                int activado = 0;
                aux.setActivado(activado);
            }
            aux.addRol(request.getParameter("rol"));
            if (ConexionEstatica.editarUsuario(aux)) {
                LinkedList listaPersonas = ConexionEstatica.getPersonas();
                session.setAttribute("listaPersonas", listaPersonas);
                response.sendRedirect("../Vistas/Vista_CRUD.jsp");
            }
        }

        //----------------------------------------------------------------------
        //----------------------- Si pulsamos borrar ---------------------------
        //----------------------------------------------------------------------
        if (botonPulsado.equals("Borrar")) {
            String dni = request.getParameter("dni");
            if (ConexionEstatica.borrarUsuario(dni)) {
                LinkedList listaPersonas = ConexionEstatica.getPersonas();
                session.setAttribute("listaPersonas", listaPersonas);
                response.sendRedirect("../Vistas/Vista_CRUD.jsp");
            }
        }

        //----------------------------------------------------------------------
        //--------------- Si pulsamos añadir nuevo usuario ---------------------
        //----------------------------------------------------------------------
        if (botonPulsado.equals("Crear usuario")) {
            Persona aux = new Persona();
            aux.setNombre(request.getParameter("new_nombre"));
            aux.setApellidos(request.getParameter("new_apellidos"));
            aux.setDni(request.getParameter("new_dni"));
            aux.setCorreo(request.getParameter("new_correo"));
            aux.setContra(request.getParameter("new_contra"));
            if (request.getParameter("new_onOff").equals("Activado")) {
                aux.setActivado(1);
            } else if (request.getParameter("new_onOff").equals("Desactivado")) {
                aux.setActivado(0);
            }
            if (request.getParameter("new_rol").equals("Gestor")) {
                aux.addRol("Gestor");
            } else if (request.getParameter("new_rol").equals("Administrador / Gestor")) {
                aux.addRol("Administrador / Gestor");
            }
            
            if (ConexionEstatica.addUsuario(aux)) {
                LinkedList listaPersonas = ConexionEstatica.getPersonas();
                session.setAttribute("listaPersonas", listaPersonas);
                response.sendRedirect("../Vistas/Vista_CRUD.jsp");
            }
        }
    }
    
    if (request.getParameter("cerrarSesion") != null) {
        session.removeAttribute("usuarioLogin");
        session.removeAttribute("listaPersonas");
        session.setAttribute("mensajeLogin", "Sesión cerrada correctamente");
        response.sendRedirect("../Vistas/Vista_Login.jsp");
    }
    
%>
