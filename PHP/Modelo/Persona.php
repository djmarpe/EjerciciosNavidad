<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of Persona
 *
 * @author alejandro
 */
class Persona {
   private $nombre;
   private $apellidos;
   private $dni;
   private $correo;
   private $contra;
   private $activado;
   private $roles;
   
   function __construct() {
       $this->nombre = "";
       $this->apellidos = "";
       $this->dni = "";
       $this->correo = "";
       $this->contra = "";
       $this->activado = "";
       $this->roles = [];
   }

   
   function getNombre() {
       return $this->nombre;
   }

   function getApellidos() {
       return $this->apellidos;
   }

   function getDni() {
       return $this->dni;
   }

   function getCorreo() {
       return $this->correo;
   }

   function getContra() {
       return $this->contra;
   }

   function getActivado() {
       return $this->activado;
   }

   function getRoles() {
       return $this->roles;
   }

   function setNombre($nombre): void {
       $this->nombre = $nombre;
   }

   function setApellidos($apellidos): void {
       $this->apellidos = $apellidos;
   }

   function setDni($dni): void {
       $this->dni = $dni;
   }

   function setCorreo($correo): void {
       $this->correo = $correo;
   }

   function setContra($contra): void {
       $this->contra = $contra;
   }

   function setActivado($activado): void {
       $this->activado = $activado;
   }

   function addRol($rol){
       $this->roles[] = $rol;
   }
   
}
