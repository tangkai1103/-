//
//  WebService.m
//  CCalDemo
//
//  Created by lanou3g on 15/11/23.
//  Copyright © 2015年 Mr Tang. All rights reserved.
//

#import "WebService.h"
#import <UIKit/UIKit.h>
@implementation WebService

- (void)query:(NSString *)phoneNumber {
    //设置我们之后解析XML时用的关键字，与响应报文中Body标签之间的getMobileCodeInfoResult标签对应
    _matchingElement = @"getMobileCodeInfoResult";
    //创建SOAP消息，内容格式就是网站上提示的请求报文的主体实体部分，这里使用了SOAP1.2
    NSString *soapMsg = [NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                         "<soap12:Envelope "
                         "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "
                         "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" "
                         "xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">"
                         "<soap12:Body>"
                         "<getMobileCodeInfo xmlns=\"http://WebXml.com.cn/\">"
                         "<mobileCode>%@</mobileCode>"
                         "<userID>%@</userID>"
                         "</getMobileCodeInfo>"
                         "</soap12:Body>"
                         "</soap12:Envelope>", phoneNumber, @""];
    //将这个XML字符串打印出来
    NSLog(@"%@",soapMsg);
    //创建URL，内容是请求报文中第二行主机地址加上第一行URL字段
    NSURL *url = [NSURL URLWithString:@"http://webservice.webxml.com.cn/WebServices/MobileCodeWS.asmx"];
    //根据上面的URL创建一个请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMsg length]];
    //添加请求的详细信息，与请求报文前半部分的各字段对应
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    //设置请求行方法为POST,与请求报文第一行对应
    [request setHTTPMethod:@"POST"];
    //将SOAP消息添加到请求中
    [request setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    //创建连接
    self.conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if (_conn) {
        self.webData = [NSMutableData data];
    }
    
    
}


//刚开始接受响应时调用
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(nonnull NSURLResponse *)response {
    [_webData setLength:0];
}

//每接收到一部分数据就追加到webData中
- (void)connection:(NSURLConnection *)connection didReceiveData:(nonnull NSData *)data {
    [_webData appendData:data];
}

//出现错误时调用
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    _conn = nil;
    _webData = nil;
}

//完成接受数据的时候调用
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *theXML = [[NSString alloc]initWithBytes:[_webData mutableBytes] length:[_webData length] encoding:NSUTF8StringEncoding];
    //打印出得到的XML
    NSLog(@"%@",theXML);
    //使用NSXMLParser解析出我们想要的结果
    self.xmlParser = [[NSXMLParser alloc]initWithData:_webData];
    [_xmlParser setDelegate:self];
    [_xmlParser setShouldResolveExternalEntities:YES];
    [_xmlParser parse];
}

#pragma mark --XMLParserDelegate--
//开始解析一个元素名
- (void)parser:(NSXMLParser *)parser didStartElement:(nonnull NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(nonnull NSDictionary<NSString *,NSString *> *)attributeDict {
    if ([elementName isEqualToString:_matchingElement]) {
        if (!_soapResults) {
            _soapResults = [[NSMutableString alloc]init];
        }
        _elementFound = YES;
    }
}

//追加找到的元素值，一个元素值可能要分几次追加
- (void)parser:(NSXMLParser *)parser foundCharacters:(nonnull NSString *)string {
    if (_elementFound) {
        [_soapResults appendString:string];
    }
}

//结束解析这个元素名
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:_matchingElement]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"手机号码消息" message:[NSString stringWithFormat:@"%@",_soapResults] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        _elementFound = NO;
        //强制放弃解析
        [_xmlParser abortParsing];
    }
}

//解析整个文件结束后
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    if (_soapResults) {
        _soapResults = nil;
    }
}

//出错时，例如强制结束解析
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(nonnull NSError *)parseError {
    if (_soapResults) {
        _soapResults = nil;
    }
}



@end
