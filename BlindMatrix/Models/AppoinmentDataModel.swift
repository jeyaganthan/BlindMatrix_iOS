//
//  AppoinmentDataModel.swift
//  BlindMatrix
//
//  Created by Jeyaganthan's Mac Mini on 16/09/21.
//

import Foundation
import CoreData

struct Appointment_Base : Codable {
    let status : String?
    let message : String?
    let default_order_status : String?
    let order_status : [String]?
    let default_cust_type : String?
    let salesstatus : [Salesstatus]?
    let customer_type : [String]?
    let default_title : String?
    let title_list : [String]?
    let payment_method : [Payment_method]?
    let payment_type : [Payment_type]?
    let default_source : String?
    let source_list : [String]?
    let prioritydrop : [String]?
    let appointment_type_list : [Appointment_type_list]?
    let userlist : [Userlist]?
    let priority_list : [Priority_list]?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case default_order_status = "default_order_status"
        case order_status = "order_status"
        case default_cust_type = "default_cust_type"
        case salesstatus = "salesstatus"
        case customer_type = "customer_type"
        case default_title = "default_title"
        case title_list = "title_list"
        case payment_method = "payment_method"
        case payment_type = "payment_type"
        case default_source = "default_source"
        case source_list = "source_list"
        case prioritydrop = "prioritydrop"
        case appointment_type_list = "appointment_type_list"
        case userlist = "userlist"
        case priority_list = "priority_list"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        default_order_status = try values.decodeIfPresent(String.self, forKey: .default_order_status)
        order_status = try values.decodeIfPresent([String].self, forKey: .order_status)
        default_cust_type = try values.decodeIfPresent(String.self, forKey: .default_cust_type)
        salesstatus = try values.decodeIfPresent([Salesstatus].self, forKey: .salesstatus)
        customer_type = try values.decodeIfPresent([String].self, forKey: .customer_type)
        default_title = try values.decodeIfPresent(String.self, forKey: .default_title)
        title_list = try values.decodeIfPresent([String].self, forKey: .title_list)
        payment_method = try values.decodeIfPresent([Payment_method].self, forKey: .payment_method)
        payment_type = try values.decodeIfPresent([Payment_type].self, forKey: .payment_type)
        default_source = try values.decodeIfPresent(String.self, forKey: .default_source)
        source_list = try values.decodeIfPresent([String].self, forKey: .source_list)
        prioritydrop = try values.decodeIfPresent([String].self, forKey: .prioritydrop)
        appointment_type_list = try values.decodeIfPresent([Appointment_type_list].self, forKey: .appointment_type_list)
        userlist = try values.decodeIfPresent([Userlist].self, forKey: .userlist)
        priority_list = try values.decodeIfPresent([Priority_list].self, forKey: .priority_list)
    }

}


struct Appointment_type_list : Codable {
    let typename : String?
    let typeid : String?
    let type_users : [Type_users]?

    enum CodingKeys: String, CodingKey {

        case typename = "typename"
        case typeid = "typeid"
        case type_users = "type_users"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        typename = try values.decodeIfPresent(String.self, forKey: .typename)
        typeid = try values.decodeIfPresent(String.self, forKey: .typeid)
        type_users = try values.decodeIfPresent([Type_users].self, forKey: .type_users)
    }

}

struct Userlist : Codable {
    let id : String?
    let user_name : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case user_name = "user_name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        user_name = try values.decodeIfPresent(String.self, forKey: .user_name)
    }

}

struct Type_users : Codable {
    let id : String?
    let user_name : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case user_name = "user_name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        user_name = try values.decodeIfPresent(String.self, forKey: .user_name)
    }

}

struct Salesstatus : Codable {
    let sostatus : String?
    let menuType : String?

    enum CodingKeys: String, CodingKey {

        case sostatus = "sostatus"
        case menuType = "menuType"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        sostatus = try values.decodeIfPresent(String.self, forKey: .sostatus)
        menuType = try values.decodeIfPresent(String.self, forKey: .menuType)
    }

}

struct Payment_method : Codable {
    let paymentId : String?
    let paymentMethods : String?
    let status : String?
    let default_Str : String?
    let creation_time_data : String?

    enum CodingKeys: String, CodingKey {

        case paymentId = "paymentId"
        case paymentMethods = "paymentMethods"
        case status = "Status"
        case default_Str = "Default"
        case creation_time_data = "creation_time_data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        paymentId = try values.decodeIfPresent(String.self, forKey: .paymentId)
        paymentMethods = try values.decodeIfPresent(String.self, forKey: .paymentMethods)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        default_Str = try values.decodeIfPresent(String.self, forKey: .default_Str)
        creation_time_data = try values.decodeIfPresent(String.self, forKey: .creation_time_data)
    }

}

struct Payment_type : Codable {
    let paymentTypeId : String?
    let paymentTypes : String?
    let creation_time_data : String?
    let seq_no : String?
    let status : String?

    enum CodingKeys: String, CodingKey {

        case paymentTypeId = "paymentTypeId"
        case paymentTypes = "paymentTypes"
        case creation_time_data = "creation_time_data"
        case seq_no = "seq_no"
        case status = "Status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        paymentTypeId = try values.decodeIfPresent(String.self, forKey: .paymentTypeId)
        paymentTypes = try values.decodeIfPresent(String.self, forKey: .paymentTypes)
        creation_time_data = try values.decodeIfPresent(String.self, forKey: .creation_time_data)
        seq_no = try values.decodeIfPresent(String.self, forKey: .seq_no)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }

}

struct Priority_list : Codable {
    let prioritydropid : String?
    let prioritydrop : String?
    let default_Str : String?

    enum CodingKeys: String, CodingKey {

        case prioritydropid = "prioritydropid"
        case prioritydrop = "prioritydrop"
        case default_Str = "default"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        prioritydropid = try values.decodeIfPresent(String.self, forKey: .prioritydropid)
        prioritydrop = try values.decodeIfPresent(String.self, forKey: .prioritydrop)
        default_Str = try values.decodeIfPresent(String.self, forKey: .default_Str)
    }

}






