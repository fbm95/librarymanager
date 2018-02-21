// Adaugare angajat
// Adaugare carte
// Adaugare imprumut + client

var tables = ['books', 'employees', 'customers', 'transactions'];

var current = 'books';

var Builder = (function() {
    function _carte(instance) {
        return
        `
          <tr class="carte-row">
              <td>${instance.titlu}</td>
              <td>${instance.autor}</td>
              <td>${instance.editura}</td>
              <td>${instance.an_aparitie}</td>
              <td>${instance.gen}</td>
              <td>${instance.valoare_inventar}</td>
              <td>${instance.imprumutat ? 'DA' : 'NU'}</td>
              <td>${instance.imprumutabil ? 'DA' : 'NU'}</td>
          </tr>
        `;
    };

    function _angajat(instance) {
        return
        `
          <tr class="carte-row">
              <td>${instance.nume}</td>
              <td>${instance.prenume}</td>
              <td>${instance.functie}</td>
              <td>${instance.salariu}</td>
          </tr>
        `;
    };


    function _client(instance) {
        return
        `
          <tr class="carte-row">
              <td>${instance.nume}</td>
              <td>${instance.prenume}</td>
              <td>${instance.CNP}</td>
              <td>${instance.adresa}</td>
          </tr>
        `;
    }


    function _imprumut(instance) {
        return
        `
          <tr class="carte-row">
              <td>${instance.titlu}</td>
              <td>${instance.nume}</td>
              <td>${instance.prenume}</td>
              <td>${instance.data_imprumut}</td>
              <td>${instance.data_restituire}</td>
              <td>${instance.amenda}</td>
          </tr>
        `;
    }

    return {
        Carte: _carte,
        Angajat: _angajat,
        Client: _client,
        Imprumut: _imprumut
    }
})();

$('span[name="table-type"]').click(function() {
    current = this.dataset.table;

    for(let table of tables) {
        $(`.${table}`).hide();
    }

    $(`.${this.dataset.table}`).find('tr > td').remove();

    // GET DATABASE INFO
    // $ .get(`/${this.dataset.table}`)
    //   .done(function(data){
    //
    //       for(let item of data) {
    //           switch(this.dataset.table) {
    //               case 'books':
    //                   $(`.${this.dataset.table}`).append(Builder.Carte(item));
    //                   break;
    //               case 'employees':
    //                   $(`.${this.dataset.table}`).append(Builder.Angajat(item));
    //                   break;
    //               case 'customers':
    //                   $(`.${this.dataset.table}`).append(Builder.Client(item));
    //                   break;
    //               case 'transactions':
    //                   $(`.${this.dataset.table}`).append(Builder.Imprumut(item));
    //                   break;
    //               default: break;
    //           }
    //       }
    //   });

    $(`.${this.dataset.table}`).show();
});

var Validator = (function() {
    function _carte(instance) {

        if( isNaN(instance.an_aparitie) ||
            isNaN(instance.valoare_inventar) ||
            instance.valoare_inventar <= 0 ||
            instance.an_aparitie < 0 ||
            instance.an_aparitie > ((new Date()).getYear() + 1900) ||
            !instance.titlu.trim() ||
            !instance.autor.trim() ||
            !instance.editura.trim() ||
            !instance.gen.trim()) {
              return false;
            }

        return true;
    };

    function _angajat(instance) {
        if( !instance.nume.trim() ||
            !instance.prenume.trim() ||
            !instance.functie.trim() ||
            isNaN(instance.salariu) ||
            instance.salariu < 5) {
                return false;
            }

        return true;
    };

    function _client(instance) {
        console.log(instance);
        if( !instance.nume.trim() ||
            !instance.prenume.trim() ||
            instance.CNP.length !== 13 ||
            !instance.adresa.trim() ||
            isNaN(instance.CNP) ||
            instance.CNP[0] < 1 || instance.CNP[0] > 2 ||
            instance.CNP.substr(3,2) < 0 || instance.CNP.substr(3,2) > 12 ||
            instance.CNP.substr(5,2) < 0 || instance.CNP.substr(5,2) > 31 ) {
                return false;
            }

        return true;
    };

    function _imprumut(instance) {


        return true;
    }

    function _selectByCurrent(instance) {
        switch(current) {
            case 'books':
                return _carte(instance);
            case 'employees':
                return _angajat(instance);
            case 'customers':
                return _client(instance);
            case 'transactions':
                return _imprumut(instance);
            default: break;
        }
    }

    return {
        Carte: _carte,
        Angajat: _angajat,
        Client: _client,
        Imprumut: _imprumut,
        SelectByCurrent: _selectByCurrent
    }
})();

var Creator = (function() {
    function _carte() {
      return {
        titlu: $('input[name="titlu"]').val(),
        autor: $('input[name="autor"]').val(),
        editura: $('input[name="editura"]').val(),
        an_aparitie: $('input[name="an_aparitie"]').val(),
        gen: $('input[name="gen"]').val(),
        valoare_inventar: $('input[name="valoare_inventar"]').val()
      }
    };

    function _angajat() {
      return {
        nume: $('input[name="nume_angajat"]').val(),
        prenume: $('input[name="prenume_angajat"]').val(),
        functie: $('input[name="functie"]').val(),
        salariu: $('input[name="salariu"]').val()
      }
    };

    function _client() {
      return {
        nume: $('input[name="nume_client"]').val(),
        prenume: $('input[name="prenume_client"]').val(),
        CNP: $('input[name="CNP"]').val(),
        adresa: $('input[name="adresa"]').val()
      }
    };

    function _imprumut() {
      return {
        // id_carte: $('input[name="titlu"]').val(),
        // id_client: $('input[name="titlu"]').val(),
        // data_imprumut: $('input[name="titlu"]').val(),
        // data_returnare: $('input[name="titlu"]').val()
      }
    };

    function _selectByCurrent() {
        switch(current) {
            case 'books':
                return _carte();
            case 'employees':
                return _angajat();
            case 'customers':
                return _client();
            case 'transactions':
                return _imprumut();
            default: break;
        }
    };

    return {
        Carte: _carte,
        Angajat: _angajat,
        Client: _client,
        Imprumut: _imprumut,
        SelectByCurrent: _selectByCurrent
    }
})();

$('.form-submit').click(function() {
  var object = Creator.SelectByCurrent();

  if(object) {
      if(Validator.SelectByCurrent(object)) {
          // Send object to API endpoint

          $('input').val('');
      } else {
          alert("You did not complete fields correctly!");
      }
  }
});
