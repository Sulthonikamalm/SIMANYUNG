/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

public class Device {

    // Default constructor
    public Device() {
    }

    private int device_id;
    private String name;
    private String brand;
    private String category;
    private int price;
    private String operatingSystem;
    private String battery;
    private String storage;
    private int memory;
    private String display;
    private String graphicsCard;
    private String graphicsCardType;
    private String processor;
    private String url;
    private String poster_url;

    public Device(int deviceId, String name, String brand, String category, int price, String operatingSystem,
            String battery, String storage, int memory, String display, String graphicsCard, String graphicsCardType,
            String processor, String poster_url) {
        this.device_id = deviceId;
        this.name = name;
        this.brand = brand;
        this.category = category;
        this.price = price;
        this.operatingSystem = operatingSystem;
        this.battery = battery;
        this.storage = storage;
        this.memory = memory;
        this.display = display;
        this.graphicsCard = graphicsCard;
        this.graphicsCardType = graphicsCardType;
        this.processor = processor;
        this.poster_url = poster_url;

    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getPoster_url() {
        return poster_url;
    }

    public void setPoster_url(String poster_url) {
        this.poster_url = poster_url;
    }

    public int getDeviceId() {
        return device_id;
    }

    public void setDeviceId(int device_id) {
        this.device_id = device_id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    }

    public String getOperatingSystem() {
        return operatingSystem;
    }

    public void setOperatingSystem(String operatingSystem) {
        this.operatingSystem = operatingSystem;
    }

    public String getBattery() {
        return battery;
    }

    public void setBattery(String battery) {
        this.battery = battery;
    }

    public String getStorage() {
        return storage;
    }

    public void setStorage(String storage) {
        this.storage = storage;
    }

    public int getMemory() {
        return memory;
    }

    public void setMemory(int memory) {
        this.memory = memory;
    }

    public String getDisplay() {
        return display;
    }

    public void setDisplay(String display) {
        this.display = display;
    }

    public String getGraphicsCard() {
        return graphicsCard;
    }

    public void setGraphicsCard(String graphicsCard) {
        this.graphicsCard = graphicsCard;
    }

    public String getGraphicsCardType() {
        return graphicsCardType;
    }

    public void setGraphicsCardType(String graphicsCardType) {
        this.graphicsCardType = graphicsCardType;
    }

    public String getProcessor() {
        return processor;
    }

    public void setProcessor(String processor) {
        this.processor = processor;
    }
}
