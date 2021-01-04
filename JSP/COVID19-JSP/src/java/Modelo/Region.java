package Modelo;

/**
 *
 * @author alejandro
 */
public class Region {

    private String semana;
    private String region;
    private int numInfectados;
    private int numFallecidos;
    private int numAltas;

    public Region() {
        this.semana = "";
        this.region = "";
        this.numInfectados = 0;
        this.numFallecidos = 0;
        this.numAltas = 0;
    }

    public String getSemana() {
        return semana;
    }

    public void setSemana(String semana) {
        this.semana = semana;
    }

    public String getRegion() {
        return region;
    }

    public void setRegion(String region) {
        this.region = region;
    }

    public int getNumInfectados() {
        return numInfectados;
    }

    public void setNumInfectados(int numInfectados) {
        this.numInfectados = numInfectados;
    }

    public int getNumFallecidos() {
        return numFallecidos;
    }

    public void setNumFallecidos(int numFallecidos) {
        this.numFallecidos = numFallecidos;
    }

    public int getNumAltas() {
        return numAltas;
    }

    public void setNumAltas(int numAltas) {
        this.numAltas = numAltas;
    }

}
