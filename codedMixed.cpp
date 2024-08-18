// Patch name
inlet
{
  type             codedMixed;
  refValue         uniform (0 0 0); // Value for fixedValue type
  refGradient      uniform (0 0 0);
  valueFraction    uniform 1; // Value fraction at 1 means fixedValue, and 0 means zeroGradient

  name             codedTimeDependentPatch; // Name of the BC

  code
    #{
        const scalar t = this->db().time().value();

        if (t >= 4) // Fixed value type within the first 4 seconds
        {
          this->valueFraction() = 1; // = 0 if zeroGradient
          this->refvalue() = vector(0,0,0); // 0 units at z+ direction ; = 0, if zeroGradient
          this->refGrad() = 0;
        }
        else
        {
          this->valueFraction() = 1; // = 0 if zeroGradient
          this->refvalue() = vector(0,0,3); // 3 units at z+ direction ; = 0, if zeroGradient
          this->refGrad() = 0;
        }
    #};
}
