package Modelo;

import Auxiliar.Constantes;
import java.sql.*;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.JOptionPane;

public class ConexionEstatica {

    //********************* Atributos *************************
    private static java.sql.Connection Conex;
    //Atributo a través del cual hacemos la conexión física.
    private static java.sql.Statement Sentencia_SQL;
    //Atributo que nos permite ejecutar una sentencia SQL
    private static java.sql.ResultSet Conj_Registros;

    public static void nueva() {
        try {
            //Cargar el driver/controlador
            //String controlador = "com.mysql.jdbc.Driver";
            //String controlador = "com.mysql.cj.jdbc.Driver";
            //String controlador = "oracle.jdbc.driver.OracleDriver";
            //String controlador = "sun.jdbc.odbc.JdbcOdbcDriver"; 
            String controlador = "org.mariadb.jdbc.Driver"; // MariaDB la version libre de MySQL (requiere incluir la librería jar correspondiente).
            //Class.forName("org.mariadb.jdbc.Driver");              
            //Class.forName(controlador).newInstance();
            Class.forName(controlador);
            //Class.forName("com.mysql.jdbc.Driver"); 

            //String URL_BD = "jdbc:mysql://localhost:3306/" + Constantes.BBDD;
            //String URL_BD = "jdbc:mariadb://"+"localhost:3306"+"/"+Constantes.BBDD;
            //String URL_BD = "jdbc:oracle:oci:@REPASO";
            //String URL_BD = "jdbc:oracle:oci:@REPASO";
            //String URL_BD = "jdbc:odbc:REPASO";
            //String connectionString = "jdbc:mysql://localhost:3306/" + Constantes.BBDD + "?user=" + Constantes.usuario + "&password=" + Constantes.password + "&useUnicode=true&characterEncoding=UTF-8";
            //Realizamos la conexión a una BD con un usuario y una clave.
            //Conex = java.sql.DriverManager.getConnection(connectionString);
            //Conex = java.sql.DriverManager.getConnection(URL_BD, Constantes.usuario, Constantes.password);
            Conex = DriverManager.getConnection(
                    "jdbc:mariadb://localhost:3306/" + Constantes.BBDD, Constantes.usuario, Constantes.password);
            Sentencia_SQL = Conex.createStatement();
            System.out.println("Conexion realizada con éxito");
        } catch (Exception e) {
            System.err.println("Exception: " + e.getMessage());
        }
    }

    public static void cerrarBD() {
        try {
            // resultado.close();
            Conex.close();
            System.out.println("Desconectado de la Base de Datos"); // Opcional para seguridad
        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(null, ex.getMessage(), "Error de Desconexion", JOptionPane.ERROR_MESSAGE);
        }
    }

    public static boolean existeUsuario(String correo, String contra) {
        boolean existe = false;
        nueva();

        String sentencia = "SELECT * FROM " + Constantes.tablaUsuario + " WHERE correo = '" + correo + "' AND contra = '" + contra + "'";

        try {
            Conj_Registros = Sentencia_SQL.executeQuery(sentencia);
            if (Conj_Registros.next()) {
                existe = true;
            }
        } catch (SQLException ex) {
        }

        cerrarBD();
        return existe;
    }

    public static Persona getPersona(String correo, String contra) {
        Persona aux = new Persona();
        nueva();

        String sentencia = "Select Usuario.Nombre, Usuario.Apellidos, Usuario.DNI, Usuario.Correo, Usuario.Contra, Usuario.Activado, Rol.Rol from Usuario, Rol, AsignacionRol where Usuario.Correo = '" + correo + "' and Usuario.Contra = '" + contra + "' and AsignacionRol.DNI = Usuario.DNI and AsignacionRol.idRol=Rol.idRol;";

        try {
            Conj_Registros = Sentencia_SQL.executeQuery(sentencia);
            while (Conj_Registros.next()) {
                aux.setNombre(Conj_Registros.getString("nombre"));
                aux.setApellidos(Conj_Registros.getString("apellidos"));
                aux.setDni(Conj_Registros.getString("dni"));
                aux.setCorreo(Conj_Registros.getString("correo"));
                aux.setContra(Conj_Registros.getString("contra"));
                aux.setActivado(Conj_Registros.getInt("activado"));
                aux.addRol(Conj_Registros.getString("Rol"));
            }
        } catch (SQLException ex) {
        }

        cerrarBD();
        return aux;
    }

    public static LinkedList getPersonas() {
        LinkedList aux = new LinkedList();
        nueva();

        String sentencia = "Select Usuario.Nombre, Usuario.Apellidos, Usuario.DNI, Usuario.Correo, Usuario.Activado, Rol.Rol from Usuario, Rol, AsignacionRol where AsignacionRol.DNI = Usuario.DNI and AsignacionRol.idRol=Rol.idRol;";

        try {
            Conj_Registros = Sentencia_SQL.executeQuery(sentencia);
            while (Conj_Registros.next()) {
                Persona p = new Persona();
                p.setNombre(Conj_Registros.getString("nombre"));
                p.setApellidos(Conj_Registros.getString("apellidos"));
                p.setDni(Conj_Registros.getString("dni"));
                p.setCorreo(Conj_Registros.getString("correo"));
                p.setActivado(Conj_Registros.getInt("activado"));
                p.addRol(Conj_Registros.getString("Rol"));
                aux.add(p);
            }
        } catch (SQLException ex) {
        }

        cerrarBD();
        return aux;
    }

    public static boolean editarUsuario(Persona aux) {
        boolean editado = false;
        nueva();

        //Editamos al usuario de la tabla de Usuario
        String sentencia1 = "UPDATE Usuario SET Correo = '" + aux.getCorreo() + "', Activado = " + aux.getActivado() + " WHERE DNI = '" + aux.getDni() + "'";

        try {
            Sentencia_SQL.executeUpdate(sentencia1);
            //Obtenemos el rol nuevo del usuario
            LinkedList roles = aux.getRoles();
            if (roles.get(0).equals("Gestor")) {
                //Borramos el anterior rol de la BBDD
                String sentencia2 = "DELETE FROM AsignacionRol WHERE dni = '" + aux.getDni() + "'";
                Sentencia_SQL.executeUpdate(sentencia2);
                //Le añadimos el nuevo rol
                String sentencia3 = "INSERT INTO AsignacionRol values(1,'" + aux.getDni() + "')";
                Sentencia_SQL.executeUpdate(sentencia3);
                editado = true;
            }

            if (roles.get(0).equals("Administrador / Gestor")) {
                //Borramos el anterior rol de la BBDD
                String sentencia2 = "DELETE FROM AsignacionRol WHERE dni = '" + aux.getDni() + "'";
                Sentencia_SQL.executeUpdate(sentencia2);
                //Le añadimos el nuevo rol
                String sentencia3 = "INSERT INTO AsignacionRol values(2,'" + aux.getDni() + "')";
                Sentencia_SQL.executeUpdate(sentencia3);
                editado = true;
            }
        } catch (SQLException ex) {
        }

        cerrarBD();
        return editado;
    }

    public static boolean borrarUsuario(String dni) {
        boolean deleteado = false;
        nueva();

        //Borramos al usuario de la tabla de Usuario
        String sentencia1 = "DELETE FROM Usuario WHERE DNI = '" + dni + "'";

        try {
            Sentencia_SQL.executeUpdate(sentencia1);
            //Borramos el usuario de AsignacionRol
            String sentencia2 = "DELETE FROM AsignacionRol WHERE DNI = '" + dni + "'";
            Sentencia_SQL.executeUpdate(sentencia2);
            deleteado = true;
        } catch (SQLException ex) {
        }

        cerrarBD();
        return deleteado;
    }

    public static boolean addUsuario(Persona aux) {
        boolean add = false;
        int idRol;
        nueva();

        String sentencia1 = "INSERT INTO Usuario VALUES('" + aux.getNombre() + "','" + aux.getApellidos() + "','" + aux.getDni() + "','" + aux.getCorreo() + "','" + aux.getContra() + "'," + aux.getActivado() + ")";

        try {
            Sentencia_SQL.executeUpdate(sentencia1);
            LinkedList rol = aux.getRoles();
            String sentencia2 = "SELECT idRol FROM Rol WHERE Rol = '" + rol.get(0) + "'";
            Conj_Registros = Sentencia_SQL.executeQuery(sentencia2);
            if (Conj_Registros.next()) {
                idRol = Conj_Registros.getInt("idRol");
                String sentencia3 = "INSERT INTO AsignacionRol VALUES(" + idRol + ",'" + aux.getDni() + "')";
                Sentencia_SQL.executeUpdate(sentencia3);
                add = true;
            }
        } catch (SQLException ex) {
        }
        cerrarBD();
        return add;
    }

    public static LinkedList getSemanas() {
        LinkedList aux = new LinkedList();
        nueva();

        String sentencia = "SELECT * FROM Semana";

        try {
            Conj_Registros = Sentencia_SQL.executeQuery(sentencia);
            while (Conj_Registros.next()) {
                aux.add(Conj_Registros.getString("Semana"));
            }
        } catch (SQLException ex) {
        }

        cerrarBD();
        return aux;
    }

    public static LinkedList getRegiones(String semana) {
        LinkedList aux = new LinkedList();
        int idSemana = 0;
        int idRegion = 0;
        String nombreRegion = "";
        nueva();

        try {
            Region r = null;
            //Obtenemos el idSemana según la semana que vayamos a filtrar
            String sentencia1 = "SELECT idSemana FROM Semana WHERE Semana = '" + semana + "'";
            Conj_Registros = Sentencia_SQL.executeQuery(sentencia1);
            if (Conj_Registros.next()) {
                idSemana = Conj_Registros.getInt("idSemana");

                String sentencia2 = "SELECT * FROM InfeccionSemanal WHERE idSemana = " + idSemana;
                Conj_Registros = Sentencia_SQL.executeQuery(sentencia2);
                while (Conj_Registros.next()) {
                    r = new Region();
                    r.setSemana(semana);
                    r.setNumInfectados(Conj_Registros.getInt("NumInfectados"));
                    r.setNumFallecidos(Conj_Registros.getInt("NumFallecidos"));
                    r.setNumAltas(Conj_Registros.getInt("NumAltas"));
                    r.setRegion(String.valueOf(Conj_Registros.getInt("idRegion")));
                    aux.add(r);
                }

            }
        } catch (SQLException ex) {
        }
        cerrarBD();
        return aux;
    }

    public static LinkedList getNombreRegiones(LinkedList regiones) {
        nueva();

        for (int i = 0; i < regiones.size(); i++) {
            Region r = (Region) regiones.get(i);
            String sentencia = "SELECT Nombre FROM Region WHERE idRegion = " + r.getRegion();
            try {
                Conj_Registros = Sentencia_SQL.executeQuery(sentencia);
                if (Conj_Registros.next()) {
                    r.setRegion(Conj_Registros.getString("Nombre"));
                }
            } catch (SQLException ex) {
            }
        }

        cerrarBD();
        return regiones;
    }

    public static int getIdSemana(String semana) {
        int idSemana = 0;
        nueva();

        String sentencia = "SELECT idSemana FROM Semana WHERE Semana = '" + semana + "'";

        try {
            Conj_Registros = Sentencia_SQL.executeQuery(sentencia);
            if (Conj_Registros.next()) {
                idSemana = Conj_Registros.getInt("idSemana");
            }
        } catch (SQLException ex) {
        }

        cerrarBD();
        return idSemana;
    }

    public static int getIdRegion(String region) {
        int idRegion = 0;
        nueva();

        String sentencia = "SELECT idRegion FROM Region WHERE Nombre = '" + region + "'";

        try {
            Conj_Registros = Sentencia_SQL.executeQuery(sentencia);
            if (Conj_Registros.next()) {
                idRegion = Conj_Registros.getInt("idRegion");
            }
        } catch (SQLException ex) {
        }

        cerrarBD();
        return idRegion;
    }

    public static boolean editarRegion(Region r) {
        boolean editado = false;
        nueva();

        String sentencia = "UPDATE InfeccionSemanal SET NumInfectados = " + r.getNumInfectados() + ", NumFallecidos = " + r.getNumFallecidos() + ", NumAltas = " + r.getNumAltas() + " WHERE idSemana = " + r.getSemana() + " AND idRegion = " + r.getRegion();

        try {
            Sentencia_SQL.executeUpdate(sentencia);
            editado = true;
        } catch (SQLException ex) {
        }

        cerrarBD();
        return editado;
    }

    public static boolean borrarRegionDeSemana(int idSemana, int idRegion) {
        boolean deleteado = false;
        nueva();

        String sentencia = "DELETE FROM InfeccionSemanal WHERE idSemana = " + idSemana + " AND idRegion = " + idRegion;

        try {
            Sentencia_SQL.executeUpdate(sentencia);
            deleteado = true;
        } catch (SQLException ex) {
        }

        cerrarBD();
        return deleteado;
    }

    public static LinkedList getRegionesDisponibles(int idSemana) {
        LinkedList aux = new LinkedList();
        nueva();

        String sentencia = "SELECT Nombre FROM Region WHERE idRegion NOT IN (SELECT idRegion FROM InfeccionSemanal WHERE idSemana = " + idSemana + ")";

        try {
            Conj_Registros = Sentencia_SQL.executeQuery(sentencia);
            while (Conj_Registros.next()) {
                aux.add(Conj_Registros.getString("Nombre"));
            }
        } catch (SQLException ex) {
        }

        cerrarBD();
        return aux;
    }

    public static boolean addRegionASemana(Region r) {
        boolean add = false;
        nueva();

        String sentencia = "INSERT INTO InfeccionSemanal VALUES(" + r.getSemana() + "," + r.getRegion() + "," + r.getNumInfectados() + "," + r.getNumFallecidos() + "," + r.getNumAltas() + ")";

        try {
            Sentencia_SQL.executeUpdate(sentencia);
            add = true;
        } catch (SQLException ex) {
        }

        cerrarBD();
        return add;
    }

    public static LinkedList getTodasRegiones() {
        LinkedList aux = new LinkedList();
        RegionAux r = null;
        nueva();

        String sentencia = "SELECT * FROM Region";

        try {
            Conj_Registros = Sentencia_SQL.executeQuery(sentencia);
            while (Conj_Registros.next()) {
                r = new RegionAux();
                r.setIdRegion(Conj_Registros.getInt("idRegion"));
                r.setNombre(Conj_Registros.getString("Nombre"));
                aux.add(r);
            }
        } catch (SQLException ex) {
        }

        cerrarBD();
        return aux;
    }

    public static boolean editarNombreRegion(RegionAux r) {
        boolean editado = false;
        nueva();

        String sentencia = "UPDATE Region SET Nombre = '" + r.getNombre() + "' WHERE idRegion = " + r.getIdRegion();

        try {
            Sentencia_SQL.executeUpdate(sentencia);
            editado = true;
        } catch (SQLException ex) {
        }

        cerrarBD();
        return editado;
    }

    public static boolean editarNombreSemana(SemanaAux s) {
        boolean editado = false;
        nueva();

        String sentencia = "UPDATE Semana SET Semana = '" + s.getSemana() + "' WHERE idSemana = " + s.getIdSemana();

        try {
            Sentencia_SQL.executeUpdate(sentencia);
            editado = true;
        } catch (SQLException ex) {
        }

        cerrarBD();
        return editado;
    }

    public static boolean borrarNombreRegion(RegionAux r) {
        boolean deleteado = false;
        nueva();

        String sentencia = "DELETE FROM Region WHERE idRegion  =  " + r.getIdRegion();

        try {
            Sentencia_SQL.executeUpdate(sentencia);
            deleteado = true;
        } catch (SQLException ex) {
        }

        cerrarBD();
        return deleteado;
    }

    public static boolean borrarNombreSemana(SemanaAux s) {
        boolean deleteado = false;
        nueva();

        String sentencia = "DELETE FROM Semana WHERE idSemana  =  " + s.getIdSemana();

        try {
            Sentencia_SQL.executeUpdate(sentencia);
            deleteado = true;
        } catch (SQLException ex) {
        }

        cerrarBD();
        return deleteado;
    }

    public static boolean addNombreRegion(RegionAux r) {
        boolean add = false;
        nueva();

        String sentencia = "INSERT INTO Region VALUES(NULL,'" + r.getNombre() + "')";

        try {
            Sentencia_SQL.executeUpdate(sentencia);
            add = true;
        } catch (SQLException ex) {
        }

        cerrarBD();
        return add;
    }
    
    public static boolean addNombreSemana(SemanaAux s) {
        boolean add = false;
        nueva();

        String sentencia = "INSERT INTO Semana VALUES(NULL,'" + s.getSemana()+ "')";

        try {
            Sentencia_SQL.executeUpdate(sentencia);
            add = true;
        } catch (SQLException ex) {
        }

        cerrarBD();
        return add;
    }

    public static LinkedList getTodasSemanas() {
        LinkedList aux = new LinkedList();
        SemanaAux s = null;
        nueva();

        String sentencia = "SELECT * FROM Semana";

        try {
            Conj_Registros = Sentencia_SQL.executeQuery(sentencia);
            while (Conj_Registros.next()) {
                s = new SemanaAux();
                s.setIdSemana(Conj_Registros.getInt("idSemana"));
                s.setSemana(Conj_Registros.getString("Semana"));
                aux.add(s);
            }
        } catch (SQLException ex) {
        }

        cerrarBD();
        return aux;
    }

//
//    public static boolean enviarMensaje(String emisor, String receptor, String asunto, String cuerpo) {
//        nueva();
//        boolean enviado = false;
//
//        String sentencia = "Insert into " + Constantes.tablaMensaje + " values( Null, '" + asunto + "', '" + cuerpo + "', '" + emisor + "', '" + receptor + "')";
//
//        try {
//            Sentencia_SQL.executeUpdate(sentencia);
//            enviado = true;
//        } catch (SQLException ex) {
//        }
//
//        cerrarBD();
//        return enviado;
//
//    }
//
//    public static int existeUsuarioMensaje(String usuario) {
//        nueva();
//
//        //cod = 0 --> Todo OK
//        int cod = -9;
//
//        String sentencia = "Select * from " + Constantes.tablaUsuario + " where Email = '" + usuario + "';";
//
//        try {
//            ConexionEstatica.Conj_Registros = ConexionEstatica.Sentencia_SQL.executeQuery(sentencia);
//            if (ConexionEstatica.Conj_Registros.next()) {
//                cod = 0;
//            }
//        } catch (SQLException ex) {
//            cod = ex.getErrorCode();
//        }
//
//        cerrarBD();
//
//        return cod;
//
//    }
//
//    public static int existeUsuario(String usuario, String clave) {
//        nueva();
//
//        //cod = 0 --> Todo OK
//        int cod = -9;
//
//        String sentencia = "Select * from " + Constantes.tablaUsuario + " where Email = '" + usuario + "' and Contra = '" + clave + "';";
//
//        try {
//            ConexionEstatica.Conj_Registros = ConexionEstatica.Sentencia_SQL.executeQuery(sentencia);
//            if (ConexionEstatica.Conj_Registros.next()) {
//                cod = 0;
//            }
//        } catch (SQLException ex) {
//            cod = ex.getErrorCode();
//        }
//
//        cerrarBD();
//
//        return cod;
//
//    }
//
//    public static boolean addUsuario(Persona p) {
//        nueva();
//        boolean ok = false;
//
//        //--------------------- Insertamos en la tabla Usuarios ----------------
//        String sentencia1 = "Insert into Usuario values('" + p.getNombre() + "', '" + p.getApellidos() + "', '" + p.getDni() + "', '" + p.getEmail() + "','" + p.getContra() + "', " + p.getEdad() + ", '" + p.getFoto() + "', " + p.getSexo() + ", " + p.getActivado() + ");";
//
//        try {
//            Sentencia_SQL.executeUpdate(sentencia1);
//            ok = true;
//        } catch (SQLException ex) {
//        }
//
//        //--------------------- Asignamos Rol en la tabla ----------------------
//        String sentencia2 = "Insert into AsignacionRol values(Null, '2', '" + p.getEmail() + "');";
//
//        try {
//            Sentencia_SQL.executeUpdate(sentencia2);
//            ok = true;
//        } catch (SQLException ex) {
//        }
//
//        cerrarBD();
//        return ok;
//    }
//
//    public static boolean eliminarUsuario(String usuario, String clave) {
//        nueva();
//
//        boolean eliminado = false;
//
//        //------------------ Eliminacion de la tabla Usuarios ------------------
//        String sentencia1 = "delete from Usuario where Email = '" + usuario + "' and Contra = '" + clave + "';";
//        try {
//
//            Sentencia_SQL.executeUpdate(sentencia1);
//            eliminado = true;
//
//        } catch (SQLException ex) {
//        }
//
//        //----------------- Eliminacion de los roles asignados ----------------
//        String sentencia2 = "delete from AsignacionRol where emailUsuario = '" + usuario + "';";
//        try {
//            Sentencia_SQL.executeUpdate(sentencia2);
//            eliminado = true;
//        } catch (SQLException ex) {
//        }
//
//        cerrarBD();
//        return eliminado;
//    }
//
//    public static boolean modificarUsuario(Persona p) {
//        nueva();
//        boolean modificado = false;
//
//        //------------------- Modificando en la tabla Usuario ------------------
//        String sentencia1 = "update Usuario set Nombre = '" + p.getNombre() + "', Apellidos = '" + p.getApellidos() + "', DNI = '" + p.getDni() + "', Email='" + p.getEmail() + "', Contra='" + p.getContra() + "', Edad=" + p.getEdad() + ", Sexo=" + p.getSexo() + ", Activado=" + p.getActivado() + " Where Email='" + p.getEmail() + "'";
//
//        try {
//            Sentencia_SQL.executeUpdate(sentencia1);
//            modificado = true;
//        } catch (SQLException ex) {
//        }
//
//        //---------------- Modificando en la tabla AsignacionRol ---------------
//        if (p.getEsAdmin() == 1) {
//            if (!ConexionEstatica.esAdmin(p.getEmail())) {
//                String sentencia2 = "Insert into AsignacionRol values(Null, '1', '" + p.getEmail() + "');";
//                try {
//                    nueva();
//                    Sentencia_SQL.executeUpdate(sentencia2);
//                    cerrarBD();
//                    modificado = true;
//                } catch (SQLException ex) {
//                }
//            }
//        }
//
//        if (p.getEsAdmin() == 0) {
//            if (ConexionEstatica.esAdmin(p.getEmail())) {
//                String sentencia2 = "Delete from AsignacionRol Where emailUsuario = '" + p.getEmail() + "' and idRol=1;";
//                try {
//                    nueva();
//                    Sentencia_SQL.executeUpdate(sentencia2);
//                    cerrarBD();
//                    modificado = true;
//                } catch (SQLException ex) {
//                }
//            }
//        }
//
//        cerrarBD();
//        return modificado;
//    }
//
//    public static Persona getPersona(String usuario, String clave) {
//        nueva();
//
//        Persona p = new Persona();
//
//        String sentencia = "Select Usuario.Nombre, Usuario.Apellidos, Usuario.DNI, Usuario.Email, Usuario.Contra, Usuario.Edad, Usuario.Foto, Usuario.Sexo, Rol.Rol from Usuario, Rol, AsignacionRol where Usuario.Email = '" + usuario + "' and Usuario.Contra = '" + clave + "' and AsignacionRol.emailUsuario = Usuario.Email and AsignacionRol.idRol=Rol.idRol;";
//
//        try {
//            Conj_Registros = Sentencia_SQL.executeQuery(sentencia);
//            while (Conj_Registros.next()) {
//                p.setNombre(Conj_Registros.getString("Nombre"));
//                p.setApellidos(Conj_Registros.getString("Apellidos"));
//                p.setDni(Conj_Registros.getString("DNI"));
//                p.setEmail(Conj_Registros.getString("Email"));
//                p.setContra(Conj_Registros.getString("Contra"));
//                p.setEdad(Conj_Registros.getString("Edad"));
//                //p.setFoto(Conj_Registros.getString("Foto"));
//                p.setSexo(Conj_Registros.getInt("Sexo"));
//                p.addRol(Conj_Registros.getString("Rol"));
//            }
//
//        } catch (SQLException ex) {
//        }
//        cerrarBD();
//        return p;
//    }
//
//    public static LinkedList<Persona> getGenteCercana(Persona p) {
//        nueva();
//        LinkedList<Persona> lp = new LinkedList<>();
//        Persona aux = null;
//        String sentencia = "select * from " + Constantes.tablaUsuario + " Where DNI <> '" + p.getDni() + "';";
//
//        try {
//            Conj_Registros = Sentencia_SQL.executeQuery(sentencia);
//            while (Conj_Registros.next()) {
//                aux = new Persona();
//                aux.setNombre(Conj_Registros.getString("Nombre"));
//                aux.setApellidos(Conj_Registros.getString("Apellidos"));
//                aux.setDni(Conj_Registros.getString("DNI"));
//                aux.setEmail(Conj_Registros.getString("Email"));
//                aux.setContra(Conj_Registros.getString("Contra"));
//                aux.setEdad(Conj_Registros.getString("Edad"));
//                aux.setFoto(Conj_Registros.getString("Foto"));
//                aux.setActivado(Conj_Registros.getInt("Activado"));
//                aux.setSexo(Conj_Registros.getInt("Sexo"));
//                lp.add(aux);
//            }
//        } catch (SQLException ex) {
//        }
//
//        cerrarBD();
//        return lp;
//    }
//
//    public static LinkedList getRoles() {
//        nueva();
//
//        LinkedList roles = new LinkedList();
//
//        String sentencia = "Select Rol from " + Constantes.tablaRol;
//
//        try {
//            Conj_Registros = Sentencia_SQL.executeQuery(sentencia);
//            while (Conj_Registros.next()) {
//                roles.add(Conj_Registros.getString("Rol"));
//            }
//        } catch (SQLException ex) {
//        }
//        cerrarBD();
//        return roles;
//    }
//
//    public static LinkedList getAdministradores() {
//        nueva();
//        LinkedList administradores = new LinkedList();
//        Persona p = null;
//        String sentencia = "select * from Usuario, AsignacionRol WHERE AsignacionRol.emailUsuario=Usuario.Email and AsignacionRol.idRol=1;";
//
//        try {
//            Conj_Registros = Sentencia_SQL.executeQuery(sentencia);
//            while (Conj_Registros.next()) {
//                p = new Persona();
//                p.setNombre(Conj_Registros.getString("Nombre"));
//                p.setApellidos(Conj_Registros.getString("Apellidos"));
//                p.setDni(Conj_Registros.getString("DNI"));
//                p.setEmail(Conj_Registros.getString("Email"));
//                p.setContra(Conj_Registros.getString("Contra"));
//                p.setEdad(Conj_Registros.getString("Edad"));
//                p.setSexo(Conj_Registros.getInt("Sexo"));
//                p.setActivado(Conj_Registros.getInt("Activado"));
//                administradores.add(p);
//            }
//        } catch (SQLException ex) {
//        }
//
//        cerrarBD();
//        return administradores;
//    }
//
//    public static LinkedList getUsuarios() {
//        nueva();
//        LinkedList usuarios = new LinkedList();
//        Persona p = null;
//        String sentencia = "select * from Usuario, AsignacionRol WHERE AsignacionRol.emailUsuario=Usuario.Email and AsignacionRol.idRol=2;";
//
//        try {
//            Conj_Registros = Sentencia_SQL.executeQuery(sentencia);
//            while (Conj_Registros.next()) {
//                p = new Persona();
//                p.setNombre(Conj_Registros.getString("Nombre"));
//                p.setApellidos(Conj_Registros.getString("Apellidos"));
//                p.setDni(Conj_Registros.getString("DNI"));
//                p.setEmail(Conj_Registros.getString("Email"));
//                p.setContra(Conj_Registros.getString("Contra"));
//                p.setEdad(Conj_Registros.getString("Edad"));
//                p.setSexo(Conj_Registros.getInt("Sexo"));
//                p.setActivado(Conj_Registros.getInt("Activado"));
//                usuarios.add(p);
//            }
//        } catch (SQLException ex) {
//        }
//
//        cerrarBD();
//        return usuarios;
//    }
//
//    private static boolean esAdmin(String email) {
//        nueva();
//        boolean loes = false;
//        String sentencia = "Select * from AsignacionRol where emailUsuario = '" + email + "';";
//
//        try {
//            Conj_Registros = Sentencia_SQL.executeQuery(sentencia);
//            while (Conj_Registros.next()) {
//                if (Conj_Registros.getInt("idRol") == 1) {
//                    loes = true;
//                }
//            }
//        } catch (SQLException ex) {
//        }
//        cerrarBD();
//        return loes;
//    }
    private static String obtenerNombreRegion(int idRegion) {
        nueva();
        String nombreRegion = "";
        try {
            String sentencia = "SELECT Nombre FROM Region WHERE idRegion = " + idRegion;
            Conj_Registros = Sentencia_SQL.executeQuery(sentencia);
            if (Conj_Registros.next()) {
                nombreRegion = Conj_Registros.getString("Nombre");
            }
        } catch (SQLException ex) {
        }
        cerrarBD();
        return nombreRegion;
    }
}
