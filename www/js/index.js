/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
var app = {
    // Application Constructor
    initialize: function() {
        this.bindEvents();
    },
    // Bind Event Listeners
    //
    // Bind any events that are required on startup. Common events are:
    // 'load', 'deviceready', 'offline', and 'online'.
    bindEvents: function() {
        document.addEventListener('deviceready', this.onDeviceReady, false);
    },
    // deviceready Event Handler
    //
    // The scope of 'this' is the event. In order to call the 'receivedEvent'
    // function, we must explicitly call 'app.receivedEvent(...);'
    
    onDeviceReady: function() {
        var contentDiv    = document.getElementById('contentDiv'),
        getPrinters = document.getElementById('getPrinters'),
        printer = document.getElementById('printer');
        cancelPrinter = document.getElementById('cancelPrinter');
        
        var Printer = new BrotherPrinterPlugin;

        var printers = [];
        
        var successPrint = function(data){
            console.log(data);
        };
        
        var errorPrint = function(){
        };
        
        getPrinters.addEventListener('click', function() {
            Printer.getPrinters(function(data){
                printers = data;
            },
            function errorHandler(err){
                console.log(err);
            });
        });
        
        
        
        printer.addEventListener('click', function() {
            var printOptions = {
                device:'1',//1:WIFI, 0:Bluetooth
                settings:printers[0],
                pdfPath:'/pdf.pdf',
                success: successPrint,              // success callback function, argument is a json string.
                // parsed json format:
                // {success: true}
                error: errorPrint                 // error callback function, argument is a json string.
                // parsed json format:
                // {success: [boolean], available: [boolean], error: [string], dismissed: [boolean]}
            };
                                 
            alert(printOptions.settings.SelectedDeviceFromWiFi);
            
            Printer.print(printOptions);
        });
        
        cancelPrinter.addEventListener('click', function() {
            Printer.cancelPrint();
        });
    }
};

app.initialize();