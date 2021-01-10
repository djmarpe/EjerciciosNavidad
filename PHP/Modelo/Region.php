<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of Region
 *
 * @author alejandro
 */
class Region {

    private $semana;
    private $region;
    private $numInfectados;
    private $numFallecidos;
    private $numAltas;

    function __construct() {
        $this->semana = "";
        $this->region = "";
        $this->numInfectados = 0;
        $this->numFallecidos = 0;
        $this->numAltas = 0;
    }

    function getSemana() {
        return $this->semana;
    }

    function getRegion() {
        return $this->region;
    }

    function getNumInfectados() {
        return $this->numInfectados;
    }

    function getNumFallecidos() {
        return $this->numFallecidos;
    }

    function getNumAltas() {
        return $this->numAltas;
    }

    function setSemana($semana): void {
        $this->semana = $semana;
    }

    function setRegion($region): void {
        $this->region = $region;
    }

    function setNumInfectados($numInfectados): void {
        $this->numInfectados = $numInfectados;
    }

    function setNumFallecidos($numFallecidos): void {
        $this->numFallecidos = $numFallecidos;
    }

    function setNumAltas($numAltas): void {
        $this->numAltas = $numAltas;
    }

}
