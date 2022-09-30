from unicodedata import name
import scrapy


class VillagesSpider(scrapy.Spider):
    name = 'villages'
    start_urls = ['https://rajasthan.villagecodes.in/']
    def parse(self, response):
        districts = response.xpath("//td[2]/a")
        for district in districts:
            dn = district.xpath(".//text()").get()
            link = district.xpath(".//@href").get()
            yield response.follow(url=link, callback=self.parse_tehsil, meta = {"dn": dn})

    def parse_tehsil(self, response):
        dn = response.request.meta["dn"]
        tehsils = response.xpath("//td[2]/a")
        for tehsil in tehsils:
            tn = tehsil.xpath(".//text()").get()
            link = tehsil.xpath(".//@href").get()
            yield response.follow(url=link, callback=self.parse_village, meta = {"tn": tn, "dn": dn})
    
    def parse_village(self, response):
        dn = response.request.meta["dn"]
        tn = response.request.meta["tn"]

        villages = response.xpath("//td[2]/a")
        for village in villages:
            name = village.xpath(".//text()").get()
            yield{
                "District": dn,
                "Tehsil": tn,
                "Village": name
            }
