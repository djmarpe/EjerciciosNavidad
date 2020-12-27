/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo;

import java.util.LinkedList;

/**
 *
 * @author alejandro
 */
public class Persona {

    private String nombre;
    private String apellidos;
    private String dni;
    private String correo;
    private String contra;
    private int activado;
    private LinkedList roles;

    public Persona() {
        this.nombre = "";
        this.apellidos = "";
        this.dni = "";
        this.correo = "";
        this.contra = "";
        this.activado = 0;
        this.roles = new LinkedList();
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getApellidos() {
        return apellidos;
    }

    public void setApellidos(String apellidos) {
        this.apellidos = apellidos;
    }

    public String getDni() {
        return dni;
    }

    public void setDni(String dni) {
        this.dni = dni;
    }

    public String getCorreo() {
        return correo;
    }

    public void setCorreo(String correo) {
        this.correo = correo;
    }

    public String getContra() {
        return contra;
    }

    public void setContra(String contra) {
        this.contra = contra;
    }

    public int getActivado() {
        return activado;
    }

    public void setActivado(int activado) {
        this.activado = activado;
    }

    public LinkedList getRoles() {
        return roles;
    }

    public void addRol(String rol) {
        this.roles.add(rol);
    }

}
