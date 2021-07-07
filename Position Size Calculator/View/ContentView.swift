//
//  ContentView.swift
//  Position Size Calculator
//
//  Created by Aaron  Owusu on 03/07/2021.
//

import SwiftUI


public extension View {
    func dismissKeyboardOnSwipe() -> some View { modifier(DismissKeyboardOnSwipe())
    }
}
public struct DismissKeyboardOnSwipe: ViewModifier {
    public func body(content: Content) -> some View {
        #if os(macOS)
        return content
        #else
        return content.gesture(swipeGesture)
        #endif
    }
    
    private var swipeGesture: some Gesture {
        DragGesture(minimumDistance: 10, coordinateSpace: .global)
            .onChanged(endEditing)
    }
    
    private func endEditing(_ gesture: DragGesture.Value) {
        UIApplication.shared.connectedScenes
            .filter {$0.activationState == .foregroundActive}
            .map {$0 as? UIWindowScene}
            .compactMap({$0})
            .first?.windows
            .filter {$0.isKeyWindow}
            .first?.endEditing(true)
    }
}

public extension View {
    func dismissKeyboardOnTap() -> some View {
        modifier(DismissKeyboardOnTap())
    }
}

public struct DismissKeyboardOnTap: ViewModifier {
    public func body(content: Content) -> some View {
        #if os(macOS)
        return content
        #else
        return content.gesture(tapGesture)
        #endif
    }
    
    private var tapGesture: some Gesture {
        TapGesture().onEnded(endEditing)
    }
    
    private func endEditing() {
        UIApplication.shared.connectedScenes
            .filter {$0.activationState == .foregroundActive}
            .map {$0 as? UIWindowScene}
            .compactMap({$0})
            .first?.windows
            .filter {$0.isKeyWindow}
            .first?.endEditing(true)
    }
}

struct ContentView: View {
    @State private var accountBalance: Double? = 0.0
    @State private var riskPercentage:Double? = 0.0
    @State private var stopLossAmount: Int = 0
    @State private var focus = false
    
    
    var body: some View {
        NavigationView{
        ZStack{
            Image("background")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                HStack(){
                    Spacer()
                    Text("Position Size Calculator")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                      
                    Spacer()
                    Button(action: {
                        // Clears all the textfields
                        if (accountBalance != 0.0 || riskPercentage != 0.0 || stopLossAmount != 0){
                            accountBalance = 0.0
                            riskPercentage = 0.0
                            stopLossAmount = 0
                        }
                    }, label: {
                        Text("Clear")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            
                    })
                    Spacer()
                    
                }
                
                // Account Balance Text Field
                VStack{
                    HStack {
                        Text("Account Balance")
                            .fontWeight(.regular)
                            .foregroundColor(Color.white)
                            .padding(.top)
                            .padding()
                        
                        Spacer()
                    }
                    
                    
                    ZStack(alignment: .leading) {
                        if accountBalance == 0.0 { Text("$").foregroundColor(.gray)
                            .font(.largeTitle)
                            .padding(.horizontal)
                            
                        }
                        //Formats the textfiled to add the $ currency symbol annd commas where appropiate
                        CurrencyTextField("", value: self.$accountBalance, isResponder: $focus,  alwaysShowFractions: true)
                            .font(.largeTitle)
                            .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                            .padding(.horizontal)
                            .keyboardType(.decimalPad)
                        
                    }.dismissKeyboardOnSwipe()
                    .dismissKeyboardOnTap()
                    
                }
                Divider()
                    .frame( height: 1)
                    .background(Color.white)
                    .padding(.horizontal)
                
                // Risk Text Field
                VStack{
                    HStack {
                        Text("Risk (%)")
                            .fontWeight(.regular)
                            .foregroundColor(Color.white)
                            .padding(.top)
                            .padding()
                        
                        Spacer()
                    }
                    
                    
                    ZStack(alignment: .leading) {
                      
                        
                        TextField("", value: $riskPercentage, formatter: NumberFormatter())
                            .font(.largeTitle)
                            .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                            .padding(.horizontal)
                            .keyboardType(.decimalPad)
                        
                    }.dismissKeyboardOnSwipe()
                    .dismissKeyboardOnTap()
                    
                }
                Divider()
                    .frame( height: 1)
                    .background(Color.white)
                    .padding(.horizontal)
                
                // Stop loss in pips
                
                VStack{
                    HStack {
                        Text("Stop Loss (pips)")
                            .fontWeight(.regular)
                            .foregroundColor(Color.white)
                            .padding(.top)
                            .padding()
                        
                        Spacer()
                    }
                    
                    
                    ZStack(alignment: .leading) {
                        
                        TextField("", value: $stopLossAmount, formatter: NumberFormatter())
                            .font(.largeTitle)
                            .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                            .padding(.horizontal)
                            .keyboardType(.decimalPad)
                        
                    }.dismissKeyboardOnSwipe()
                    .dismissKeyboardOnTap()
                    
                }
                Divider()
                    .frame( height: 1)
                    .background(Color.white)
                    .padding(.horizontal)
                
                
                Spacer()
                
                NavigationLink(
                    destination: CurrencyView(storedAccountBalance: accountBalance, storedRisk: riskPercentage, storedStopLossAmount: stopLossAmount),
                    label: {
                        
                        HStack{
                            Text("SELECT CURRENCY PAIR")
                                .font(.headline)
                                .foregroundColor(Color.white)
                            
                            Image(systemName: "chevron.right.circle")
                                        .foregroundColor(Color.white)
                                        .font(Font.system(.title2))
                                    }
                        
                    }).disabled(self.accountBalance == 0)
                    .padding(.bottom)
                Spacer()
                
               
                            
                    
                }
               
                
            }
            
        }
        .navigationBarBackButtonHidden(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            
            
        }
    }


struct CurrencyView: View{
    var storedAccountBalance :Double?
    var storedRisk: Double?
    var storedStopLossAmount: Int
   @State var gbpUSDSelected = false
    @State var eurUSDSelected = false
    @State var audUSDSelected = false


    var body: some View{
        
            ZStack{
                Image("background")
                    .resizable()
                    .ignoresSafeArea()
                
                VStack {
            
                        Spacer()
                        Text("Position Size Calculator")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .padding(.bottom)
                          

                    Spacer()
                    
                    
                    
                    VStack{
                        Spacer()
                        
                        Text("SELECT A CURRENCY PAIR")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .padding(.bottom)
                        
                        NavigationLink(
                            destination: ResultView(finalAccountBalance: storedAccountBalance, finalstoredRisk: storedRisk, finalStopLossAmount: storedStopLossAmount),
                            label: {
                                
                                Text("GBPUSD")
                                    .fontWeight(.bold)
                                    .frame(maxWidth:.infinity)
                                    .background(Color(red: 0.224, green: 0.353, blue: 0.561))
                                    .foregroundColor(.white)
                                    .cornerRadius(15)
                                    .font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/)
                                    .padding()
                                
                                
                            })
                        NavigationLink(
                            destination: ResultView(finalAccountBalance: storedAccountBalance, finalstoredRisk: storedRisk, finalStopLossAmount: storedStopLossAmount),
                            label: {
                                
                                Text("EURUSD")
                                    .fontWeight(.bold)
                                    .frame(maxWidth:.infinity)
                                    .background(Color(red: 0.224, green: 0.353, blue: 0.561))
                                    .foregroundColor(.white)
                                    .cornerRadius(15)
                                    .font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/)
                                    .padding()
                                
                            })
                        
                        NavigationLink(
                            destination: ResultView(finalAccountBalance: storedAccountBalance, finalstoredRisk: storedRisk, finalStopLossAmount: storedStopLossAmount),
                            label: {
                                
                                Text("AUDUSD")
                                    .fontWeight(.bold)
                                    .frame(maxWidth:.infinity)
                                    .background(Color(red: 0.224, green: 0.353, blue: 0.561))
                                    .foregroundColor(.white)
                                    .cornerRadius(15)
                                    .font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/)
                                    .padding()
                                
                            })

        
                      
                        Spacer()
                        
                       
                    }
    
            }
                
                
                
        }
            
        }
        
}

struct ResultView: View{
    var finalAccountBalance :Double?
    var finalstoredRisk: Double?
    var finalStopLossAmount: Int
   
  
    
    
    var body: some View{
        // Constants hold the risk amount and lot size
        let riskAmount = (finalAccountBalance ?? 0)*(finalstoredRisk!/100)
        let lotSize = (Double(riskAmount)/Double(finalStopLossAmount) )*0.1
        ZStack{
            Image("background")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                    
                    Text("Position Size Calculator")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .padding()
                      
                    Spacer()
                
                VStack {
                    HStack{
                        Spacer()
                        VStack{
                            Text("Risk").font(.headline).fontWeight(.heavy).foregroundColor(Color.gray).padding()
                            
                            Text("\(finalstoredRisk ?? 0, specifier: "%.2f")%")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(Color.black)
                                .padding()
                            
                        }
                        Spacer()
                        Divider().frame(height:100).background(Color.gray)
                        VStack{
                            Text("Risk Amount").font(.headline).fontWeight(.heavy).foregroundColor(Color.gray).padding()
                        Text("$\(riskAmount, specifier: "%.2f")")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Color.black)
                            .padding()
                        
                        }
                        
                        Spacer()
                    }.background(Color.white)
                    HStack{
                        Spacer()
                        VStack{
                            Text("Stop Loss").font(.headline).fontWeight(.heavy).foregroundColor(Color.gray).padding([.top, .bottom, .trailing])
                            
                            Text("\(finalStopLossAmount)")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(Color.black)
                                .padding()
                            
                        }
                        Spacer()
                        Divider().frame(height:100).background(Color.gray)
                            .offset(x: -50)
                        VStack{
                            Text("Lots").font(.headline).fontWeight(.heavy).foregroundColor(Color.gray).padding([.top, .bottom, .trailing])
                            
                            Text("\(lotSize,specifier: "%.3f")")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Color.black)
                            .padding()
                        
                        }
                        
                        Spacer()
                    }.background(Color.white)
                    
                    
                    
                   
                   
                        
                    
                }
                Spacer()
                
                HStack {
                 
                    Text("Happy Trading")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hue: 0.552, saturation: 0.041, brightness: 0.834))
                    Image(systemName: "hand.thumbsup")
                        .font(Font.system(.largeTitle))
                        .foregroundColor(Color(hue: 0.552, saturation: 0.041, brightness: 0.834))
                }

                    Spacer()
                    
        
                
                
            }
            
            
        }
        
    }
}

struct Result_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
    }
}


