//
//  TimeRepository.swift
//  Core
//
//  Created by Alex Curran on 29/06/2019.
//  Copyright © 2019 Alex Curran. All rights reserved.
//

import Foundation

protocol TimeRepository {

    var borderTimeEnd: TimeOfDay { get }

    var borderTimeStart: TimeOfDay { get }

}
