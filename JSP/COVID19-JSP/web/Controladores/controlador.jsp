<%-- 
    Document   : controlador
    Created on : 26-dic-2020, 15:05:33
    Author     : alejandro
--%>

<%@page import="Modelo.SemanaAux"%>
<%@page import="Modelo.RegionAux"%>
<%@page import="Modelo.Region"%>
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
                    LinkedList semanasDisponibles = ConexionEstatica.getSemanas();
                    session.setAttribute("semanasDisponibles", semanasDisponibles);
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

    //----------------------------------------------------------------------
    //--------------- Si filtramos por alguna semana -----------------------
    //----------------------------------------------------------------------
    if (request.getParameter("semanaFiltrar") != null) {
        String semana = request.getParameter("semanaFiltrar");
        session.setAttribute("semana", semana);
        LinkedList regionesAux = ConexionEstatica.getRegiones(semana);
        LinkedList regiones = ConexionEstatica.getNombreRegiones(regionesAux);
        int idSemana = ConexionEstatica.getIdSemana((String) session.getAttribute("semana"));
        LinkedList regionesDisponibles = ConexionEstatica.getRegionesDisponibles(idSemana);
        session.setAttribute("regionesDisponibles", regionesDisponibles);
        session.setAttribute("regionesPorSemanas", regiones);
        response.sendRedirect("../Vistas/Vista_Gestor.jsp");
    }

    if (request.getParameter("semanaFiltrarIndex") != null) {
        String semana = request.getParameter("semanaFiltrarIndex");
        session.setAttribute("semana", semana);
        LinkedList regionesAux = ConexionEstatica.getRegiones(semana);
        LinkedList regiones = ConexionEstatica.getNombreRegiones(regionesAux);
        session.setAttribute("regionesPorSemanas", regiones);
        response.sendRedirect("../index.jsp");
    }

    if (request.getParameter("bt_Gestor") != null) {
        String botonPulsado = request.getParameter("bt_Gestor");
        String semana = (String) session.getAttribute("semana");
        if (botonPulsado.equals("Editar")) {

            Region r = new Region();
            //Obtenemos los id de Semana y de Region
            int idSemana = ConexionEstatica.getIdSemana((String) session.getAttribute("semana"));
            int idRegion = ConexionEstatica.getIdRegion(request.getParameter("region"));

            r.setSemana(String.valueOf(idSemana));
            r.setRegion(String.valueOf(idRegion));
            r.setNumInfectados(Integer.parseInt(request.getParameter("numInfectados")));
            r.setNumFallecidos(Integer.parseInt(request.getParameter("numFallecidos")));
            r.setNumAltas(Integer.parseInt(request.getParameter("numAltas")));
            if (ConexionEstatica.editarRegion(r)) {
                LinkedList regionesAux = ConexionEstatica.getRegiones(semana);
                LinkedList regiones = ConexionEstatica.getNombreRegiones(regionesAux);
                session.setAttribute("regionesPorSemanas", regiones);
                LinkedList regionesDisponibles = ConexionEstatica.getRegionesDisponibles(idSemana);
                session.setAttribute("regionesDisponibles", regionesDisponibles);
                response.sendRedirect("../Vistas/Vista_Gestor.jsp");
            }
        }

        if (botonPulsado.equals("Borrar")) {
            //Obtenemos los id de Semana y de Region
            int idSemana = ConexionEstatica.getIdSemana((String) session.getAttribute("semana"));
            int idRegion = ConexionEstatica.getIdRegion(request.getParameter("region"));

            if (ConexionEstatica.borrarRegionDeSemana(idSemana, idRegion)) {
                LinkedList regionesAux = ConexionEstatica.getRegiones(semana);
                LinkedList regiones = ConexionEstatica.getNombreRegiones(regionesAux);
                session.setAttribute("regionesPorSemanas", regiones);
                LinkedList regionesDisponibles = ConexionEstatica.getRegionesDisponibles(idSemana);
                session.setAttribute("regionesDisponibles", regionesDisponibles);
                response.sendRedirect("../Vistas/Vista_Gestor.jsp");
            }
        }

        if (botonPulsado.equals("Introducir region")) {
            //Obtenemos los id de Semana y de Region
            int idSemana = ConexionEstatica.getIdSemana((String) session.getAttribute("semana"));
            int idRegion = ConexionEstatica.getIdRegion(request.getParameter("regionDisponible_region"));

            Region r = new Region();
            r.setRegion(String.valueOf(idRegion));
            r.setSemana(String.valueOf(idSemana));
            r.setNumInfectados(Integer.parseInt(request.getParameter("numInfecciones_region")));
            r.setNumFallecidos(Integer.parseInt(request.getParameter("numFallecidos_region")));
            r.setNumAltas(Integer.parseInt(request.getParameter("numAltas_region")));
            if (ConexionEstatica.addRegionASemana(r)) {
                LinkedList regionesAux = ConexionEstatica.getRegiones(semana);
                LinkedList regiones = ConexionEstatica.getNombreRegiones(regionesAux);
                session.setAttribute("regionesPorSemanas", regiones);
                LinkedList regionesDisponibles = ConexionEstatica.getRegionesDisponibles(idSemana);

                session.setAttribute("regionesDisponibles", regionesDisponibles);
                response.sendRedirect("../Vistas/Vista_Gestor.jsp");
            }
        }

    }

    if (request.getParameter("verRegiones") != null) {
        LinkedList todasRegiones = ConexionEstatica.getTodasRegiones();
        session.setAttribute("todasRegiones", todasRegiones);
        response.sendRedirect("../Vistas/Vista_Region.jsp");
    }

    //**************************************************************************
    //********************** Ventana regiones **********************************
    //**************************************************************************
    if (request.getParameter("bt_Region") != null) {
        String botonPulsado = request.getParameter("bt_Region");
        RegionAux r = new RegionAux();
        if (request.getParameter("idRegion") != null) {
            int idRegion = Integer.parseInt(request.getParameter("idRegion"));
            r.setIdRegion(idRegion);
        }

        String region = request.getParameter("region");

        r.setNombre(region);

        if (botonPulsado.equals("Editar")) {
            if (ConexionEstatica.editarNombreRegion(r)) {
                LinkedList todasRegiones = ConexionEstatica.getTodasRegiones();
                session.setAttribute("todasRegiones", todasRegiones);
                response.sendRedirect("../Vistas/Vista_Region.jsp");
            }
        }

        if (botonPulsado.equals("Borrar")) {
            if (ConexionEstatica.borrarNombreRegion(r)) {
                LinkedList todasRegiones = ConexionEstatica.getTodasRegiones();
                session.setAttribute("todasRegiones", todasRegiones);
                response.sendRedirect("../Vistas/Vista_Region.jsp");
            }
        }

        if (botonPulsado.equals("Crear region")) {
            r.setNombre(request.getParameter("nuevaRegion"));
            if (ConexionEstatica.addNombreRegion(r)) {
                LinkedList todasRegiones = ConexionEstatica.getTodasRegiones();
                session.setAttribute("todasRegiones", todasRegiones);
                response.sendRedirect("../Vistas/Vista_Region.jsp");
            }
        }

    }
    
    //**************************************************************************
    //********************** Ventana semanas **********************************
    //**************************************************************************
    if (request.getParameter("bt_Semana") != null) {
        String botonPulsado = request.getParameter("bt_Semana");
        SemanaAux s = new SemanaAux();
        if (request.getParameter("idSemana") != null) {
            int idSemana = Integer.parseInt(request.getParameter("idSemana"));
            s.setIdSemana(idSemana);
        }

        String semana = request.getParameter("semana");

        s.setSemana(semana);

        if (botonPulsado.equals("Editar")) {
            if (ConexionEstatica.editarNombreSemana(s)) {
                LinkedList todasSemanas = ConexionEstatica.getTodasSemanas();
                session.setAttribute("todasSemanas", todasSemanas);
                response.sendRedirect("../Vistas/Vista_Semana.jsp");
            }
        }

        if (botonPulsado.equals("Borrar")) {
            if (ConexionEstatica.borrarNombreSemana(s)) {
                LinkedList todasSemanas = ConexionEstatica.getTodasSemanas();
                session.setAttribute("todasSemanas", todasSemanas);
                response.sendRedirect("../Vistas/Vista_Semana.jsp");
            }
        }

        if (botonPulsado.equals("Crear semana")) {
            s.setSemana(request.getParameter("nuevaSemana"));
            if (ConexionEstatica.addNombreSemana(s)) {
                LinkedList todasSemanas = ConexionEstatica.getTodasSemanas();
                session.setAttribute("todasSemanas", todasSemanas);
                response.sendRedirect("../Vistas/Vista_Semana.jsp");
            }
        }

    }

    //----------------------------------------------------------------------
    //--------------- Si pulsamos cerrar sesion ----------------------------
    //----------------------------------------------------------------------
    if (request.getParameter("cerrarSesion") != null) {
        session.removeAttribute("usuarioLogin");
        session.removeAttribute("listaPersonas");
        session.setAttribute("mensajeLogin", "Sesión cerrada correctamente");
        response.sendRedirect("../index.jsp");
    }

    if (request.getParameter("verSemanas") != null) {
        LinkedList todasSemanas = ConexionEstatica.getTodasSemanas();
        session.setAttribute("todasSemanas", todasSemanas);
        response.sendRedirect("../Vistas/Vista_Semana.jsp");
    }

    if (request.getParameter("bt_cambioRol") != null) {
        String ir = request.getParameter("bt_cambioRol");

        if (ir.equals("Ir a Admin")) {
            LinkedList listaPersonas = ConexionEstatica.getPersonas();
            session.setAttribute("listaPersonas", listaPersonas);
            response.sendRedirect("../Vistas/Vista_CRUD.jsp");
        }

        if (ir.equals("Ir a Gestor")) {
            LinkedList semanasDisponibles = ConexionEstatica.getSemanas();
            session.setAttribute("semanasDisponibles", semanasDisponibles);
            response.sendRedirect("../Vistas/Vista_Gestor.jsp");
        }
    }

%>
