from django.shortcuts import render, HttpResponse  #HttResponse es un método para dar respuesta a una petición Http a través de una url

# Create your views here.



def home(request):
    return render(request, "core/home.html")

def about(request):
    return render(request, "core/about.html")
   

def contact(request):
    return render(request, "core/contact.html")

def portfolio(request):
    return render(request, "core/portfolio.html")
        
    
    